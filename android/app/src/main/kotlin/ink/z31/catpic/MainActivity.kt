package ink.z31.catpic

import android.content.Intent
import android.net.Uri
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

    private var safResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                CHANNEL
        ).setMethodCallHandler { call, result ->


            try {
                when (call.method) {
                    "openSafDialog" -> {
                        requestSAFUri()
                        safResult = result
                    }

                    "getSafUrl" -> result.success(getSafUrl())

                    "safCreateDirectory" -> {
                        val safUrl = call.argument<String>("safUrl")!!
                        val path = call.argument<String>("path")!!
                        safCreateDirectory(safUrl, path)
                    }

                    "safIsFileExist" -> {
                        val safUrl = call.argument<String>("safUrl")!!
                        val path = call.argument<String>("path")!!
                        val fileName = call.argument<String>("fileName")!!
                        result.success(safIsFileExist(safUrl, path, fileName))
                    }

                    "safIsFile" -> {
                        val safUrl = call.argument<String>("safUrl")!!
                        val path = call.argument<String>("path")!!
                        val fileName = call.argument<String>("fileName")!!
                        result.success(safIsFile(safUrl, path, fileName))
                    }

                    "safIsDirectory" -> {
                        val safUrl = call.argument<String>("safUrl")!!
                        val path = call.argument<String>("path")!!
                        val fileName = call.argument<String>("fileName")!!
                        result.success(safIsDirectory(safUrl, path, fileName))
                    }

                    "safWalk" -> {
                        val safUrl = call.argument<String>("safUrl")!!
                        val path = call.argument<String>("path")!!
                        result.success(safWalk(safUrl, path))
                    }

                    "safWriteFile" -> {
                        val safUrl = call.argument<String>("safUrl")!!
                        val path = call.argument<String>("path")!!
                        val fileName = call.argument<String>("fileName")!!
                        val mime = call.argument<String>("mime")!!
                        val data = call.argument<ByteArray>("data")!!
                        safWriteFile(safUrl, path, fileName, mime, data)
                    }
                    
                    "safReadFile" -> {
                        val safUrl = call.argument<String>("safUrl")!!
                        val path = call.argument<String>("path")!!
                        val fileName = call.argument<String>("fileName")!!
                        result.success(safReadFile(safUrl, path, fileName))
                    }
                }
            } catch (e: Exception) {
                result.error("", e.toString(), null)
            }
        }
    }

    private fun safReadFile(safUrl: String, path: String, fileName: String): ByteArray? {
        val documentFile = safDocumentFileDir(safUrl, path)
        val file = documentFile?.findFile(fileName)
        if (file != null) {
            contentResolver.openInputStream(file.uri).use {
                it?.let {
                    return it.readBytes()
                }
                return null
            }
        }
        return null
    }


    private fun safCreateDirectory(safUrl: String, path: String): DocumentFile {
        val document = checkSaf(safUrl)
        var tmpDocumentFile: DocumentFile = document
        for (p in path.split("/")) {
            if (p.isNotEmpty()) {
                val thisPath = tmpDocumentFile.findFile(p)
                val nextPath: DocumentFile = when {
                    thisPath == null -> tmpDocumentFile.createDirectory(p)
                    thisPath.isFile -> throw Exception("目录为文件")
                    else -> thisPath
                } ?: throw Exception("创建文件目录失败")
                tmpDocumentFile = nextPath
            }
        }
        return tmpDocumentFile
    }

    private fun safDocumentFileDir(safUrl: String, path: String): DocumentFile? {
        val document = checkSaf(safUrl)
        var tmpDocumentFile: DocumentFile = document
        for (p in path.split("/")) {
            if (p.isNotEmpty()) {
                val thisPath = tmpDocumentFile.findFile(p)
                val nextPath: DocumentFile = when {
                    thisPath == null -> return null
                    thisPath.isFile -> return null
                    else -> thisPath
                }
                tmpDocumentFile = nextPath
            }
        }
        return tmpDocumentFile
    }

    private fun safIsFileExist(safUrl: String, path: String, fileName: String): Boolean {
        val documentFile = safDocumentFileDir(safUrl, path)
        return documentFile?.findFile(fileName) != null
    }

    private fun safIsFile(safUrl: String, path: String, fileName: String): Boolean {
        val documentFile = safDocumentFileDir(safUrl, path)
        return documentFile?.findFile(fileName) != null && documentFile.isFile
    }

    private fun safIsDirectory(safUrl: String, path: String, fileName: String): Boolean {
        val documentFile = safDocumentFileDir(safUrl, path)
        return documentFile?.findFile(fileName) != null && documentFile.isDirectory
    }

    private fun safWalk(safUrl: String, path: String): List<String> {
        val documentFile = safDocumentFileDir(safUrl, path)
        val files = documentFile?.listFiles()?.map { it.name!! }
        return files ?: throw Exception("目录不存在")
    }


    private fun safWriteFile(
            safUrl: String,
            path: String,
            fileName: String,
            mime: String,
            data: ByteArray
    ) {
        val documentFile = safCreateDirectory(safUrl, path)
        val file = documentFile.findFile(fileName) ?: documentFile.createFile(mime, fileName)
        if (file != null && file.isFile) {
            contentResolver.openOutputStream(file.uri, "w").use {
                it?.write(data)
                it?.close()
            }
        } else if (file?.isDirectory == true) {
            throw Exception("给定文件是目录")
        } else {
            throw Exception("创建文件失败")
        }
    }


    private fun requestSAFUri() {
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE)
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
        startActivityForResult(intent, SAF_CODE)
    }

    private fun getSafUrl(): String? {
        val safUrl = contentResolver.persistedUriPermissions
                .filter { it.isReadPermission && it.isWritePermission }
                .map { it.uri.toString() }
        return if (safUrl.isNotEmpty()) safUrl[0] else null
    }

    private fun checkSaf(safUrl: String): DocumentFile {
        contentResolver.persistedUriPermissions
                .filter { it.isReadPermission && it.isWritePermission }
                .filter { it.uri.toString() == safUrl }.let {
                    if (it.isEmpty()) throw Exception("SAF权限异常")
                }
        return DocumentFile.fromTreeUri(this, Uri.parse(safUrl)) ?: throw Exception("SAF目录不存在")
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
