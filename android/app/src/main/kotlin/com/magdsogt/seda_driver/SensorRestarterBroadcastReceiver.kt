package com.magdsoft.seda_driver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log




class SensorRestarterBroadcastReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        Log.i(
            SensorRestarterBroadcastReceiver::class.java.simpleName,
            "App Destroyed! Oooooooooooooppppssssss!!!!"
        )
        Log.i(
            SensorRestarterBroadcastReceiver::class.java.simpleName,
            "Starting Service!!!"
        )
        context.startService(Intent(context, UserBackgroundService::class.java))
    }
}