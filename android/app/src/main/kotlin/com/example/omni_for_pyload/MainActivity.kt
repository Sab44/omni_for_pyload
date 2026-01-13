package com.downloader.omni_for_pyload

import android.content.Intent
import android.os.Build
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.downloader.omni_for_pyload/click_n_load"
        
        private var methodChannel: MethodChannel? = null
        
        fun notifyFlutterServiceStopped() {
            methodChannel?.invokeMethod("onServiceStopped", null)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel = channel
        
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    startClickNLoadService()
                    result.success(true)
                }
                "stopService" -> {
                    stopClickNLoadService()
                    result.success(true)
                }
                "isRunning" -> {
                    result.success(ClickNLoadForegroundService.isServiceRunning())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun startClickNLoadService() {
        val intent = Intent(this, ClickNLoadForegroundService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            ContextCompat.startForegroundService(this, intent)
        } else {
            startService(intent)
        }
    }

    private fun stopClickNLoadService() {
        val intent = Intent(this, ClickNLoadForegroundService::class.java)
        stopService(intent)
    }
}
