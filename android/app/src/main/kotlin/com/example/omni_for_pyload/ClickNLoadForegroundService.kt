package com.example.omni_for_pyload

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

class ClickNLoadForegroundService : Service() {

    companion object {
        const val CHANNEL_ID = "click_n_load_channel"
        const val NOTIFICATION_ID = 888
        const val ACTION_STOP_SERVICE = "com.example.omni_for_pyload.STOP_CLICK_N_LOAD"
        
        private var isRunning = false
        
        fun isServiceRunning(): Boolean = isRunning
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP_SERVICE) {
            // Notify Flutter to stop the HTTP server before stopping the native service
            MainActivity.notifyFlutterServiceStopped()
            stopSelf()
            return START_NOT_STICKY
        }

        isRunning = true
        
        val notification = createNotification()
        startForeground(NOTIFICATION_ID, notification)
        
        // Return NOT_STICKY so the service won't restart if killed
        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        isRunning = false
        super.onDestroy()
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        // Called when the app is swiped away from recent apps
        // Stop the service when the app is killed
        stopSelf()
        super.onTaskRemoved(rootIntent)
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Click'n'Load Service",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Running local server for Click'n'Load"
                setShowBadge(false)
            }
            
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        // Create intent to stop the service when notification is tapped
        val stopIntent = Intent(this, ClickNLoadForegroundService::class.java).apply {
            action = ACTION_STOP_SERVICE
        }
        
        val pendingIntent = PendingIntent.getService(
            this,
            0,
            stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Click'n'Load Active")
            .setContentText("Listening on port 9666 - tap to quit service")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setOngoing(true)
            .setContentIntent(pendingIntent)
            .setAutoCancel(false)
            .build()
    }
}
