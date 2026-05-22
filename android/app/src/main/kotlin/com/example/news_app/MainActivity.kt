package com.example.news_app

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.newsapp/image_compressor"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "compressImage" -> {
                    try {
                        val bytes = call.argument<ByteArray>("bytes")
                        val quality = call.argument<Int>("quality") ?: 80

                        if (bytes == null) {
                            result.error(
                                "INVALID_ARGUMENT",
                                "Image bytes cannot be null",
                                null
                            )
                            return@setMethodCallHandler
                        }
                        val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)

                        if (bitmap == null) {
                            result.error(
                                "DECODE_ERROR",
                                "Failed to decode image bytes into Bitmap",
                                null
                            )
                            return@setMethodCallHandler
                        }
                        val outputStream = ByteArrayOutputStream()
                        bitmap.compress(Bitmap.CompressFormat.JPEG, quality, outputStream)
                        bitmap.recycle()
                        result.success(outputStream.toByteArray())

                    } catch (e: Exception) {
                        result.error(
                            "COMPRESSION_ERROR",
                            "Image compression failed: ${e.localizedMessage}",
                            null
                        )
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
