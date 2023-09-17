package com.magdsoft.seda_driver

import android.app.Service
import android.content.Intent
import android.content.SharedPreferences
import android.os.IBinder
import android.util.Log

class UserBackgroundService : Service() {

    override fun onCreate() {
        super.onCreate()
        Log.i("UserBackgroundService", "onCreate")
        val prefs: SharedPreferences =
            this.getSharedPreferences(preferenceName, MODE_PRIVATE)
        val token: String? = prefs.getString(preferenceTokenKey, null)
        println("my token: $token")
        if (token != null) {
            val apiService = RestApiService()
            apiService.toggleOnline(token)
        }
        stopService(Intent(this, UserBackgroundService::class.java))
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        super.onStartCommand(intent, flags, startId)
        return START_STICKY
    }

    override fun onDestroy() {
        Log.i("UserBackgroundService", "onDestroy!")
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}