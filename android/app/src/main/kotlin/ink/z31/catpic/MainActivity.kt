package ink.z31.catpic

import android.content.Intent
import android.net.Uri
import android.widget.Toast
import androidx.documentfile.provider.DocumentFile
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.lang.Exception

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
            } else if (call.method == "save_image") {
                val data = call.argument<ByteArray>("data")!!
                val fileName = call.argument<String>("fileName")!!
                val uri = call.argument<String>("uri")!!
                savePicture(data, fileName, uri, result)
            }
        }
    }

    private fun savePicture(data: ByteArray, fileName: String, uriStr: String, result: MethodChannel.Result?) {
        val uri = Uri.parse(uriStr)
        val permissions =
                contentResolver.persistedUriPermissions.filter { it.isReadPermission && it.isWritePermission && it.uri == uri }
        if (permissions.isEmpty()) {
            result?.error("permission", "Permission Denied", null)
        }
        Thread().run {
            try {
                val document = DocumentFile.fromTreeUri(this@MainActivity, uri)!!
                val mime = if (fileName.endsWith("jpg", ignoreCase = true) || fileName.endsWith("jpeg", ignoreCase = true)) {
                    "image/jpg"
                } else if (fileName.endsWith("png", ignoreCase = true)) {
                    "image/png"
                } else if (fileName.endsWith("png", ignoreCase = true)) {
                    "image/gif"
                } else {
                    "image/jpg"
                }
                val file = document.createFile(mime, fileName)
                if (file != null) {
                    contentResolver.openOutputStream(file.uri, "w").use {
                        it?.write(data)
                        it?.close()
                    }
                    result?.success(null)
                } else {
                    result?.error("file", "Write File Error", null)
                }
            } catch (e: Exception) {

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
                val uri: Uri? = data?.data
                uriRegister(uri)
                safResult?.success(uri?.toString() ?: "")
                safResult = null
            }
        }
    }

}
