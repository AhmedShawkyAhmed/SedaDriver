package com.magdsoft.seda_driver

import android.content.Intent
import android.content.SharedPreferences
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

const val preferenceName : String = "FlutterSharedPreferences"
const val preferenceTokenKey : String = "apiToken"

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "UserChannel"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "addToken" -> {
                    Log.i("CallNativeFromFlutter", "NativeToken: ${call.arguments}")
                    val prefs: SharedPreferences =
                        this.getSharedPreferences(preferenceName, MODE_PRIVATE)
                    prefs.edit().putString(preferenceTokenKey, call.arguments as String?).apply()
                    Log.i("CallNativeFromFlutter", "Api Token Saved Successfully")
                    result.success(null)
                }
                "removeToken" -> {
                    val prefs: SharedPreferences =
                        this.getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE)
                    prefs.edit().remove("appToken").apply()
                    Log.i("CallNativeFromFlutter", "Api Token removed Successfully")
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onDetachedFromWindow() {
        Log.i("MainActivity", "onDetachedFromWindow!")
        super.onDetachedFromWindow()
    }
    override fun onDestroy() {
        val broadcastIntent = Intent(this, SensorRestarterBroadcastReceiver::class.java)
        sendBroadcast(broadcastIntent)
        Log.i("MainActivity", "onDestroy!")
        super.onDestroy()
    }
}
