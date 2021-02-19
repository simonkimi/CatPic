package ink.z31.catpic

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "ink.z31.catpic"
        private const val SAF_CODE = 1
    }

    var safResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "saf") {
                // 请求SAF路径
                requestSAFUri()
                safResult = result
            }
        }
    }

    private fun requestSAFUri() {
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE)
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
        startActivityForResult(intent, SAF_CODE)
    }

    private fun uriRegister(uri: Uri?) {
        if (uri == null) return
        val flag = Intent.FLAG_GRANT_READ_URI_PERMISSION or
                Intent.FLAG_GRANT_WRITE_URI_PERMISSION
        contentResolver.takePersistableUriPermission(uri, flag)
        contentResolver.persistedUriPermissions
                .filter { it.isReadPermission && it.isWritePermission && it.uri != uri }
                .forEach { contentResolver.releasePersistableUriPermission(it.uri, flag) }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            SAF_CODE -> {
                val uri: Uri? = data?.data;
                uriRegister(uri)
                safResult?.success(uri?.toString() ?: "")
                safResult = null;
            }
        }
    }

}
