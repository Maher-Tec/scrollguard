package com.example.scrollguard

import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.os.IBinder
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.content.BroadcastReceiver
import android.content.IntentFilter

class OverlayService : Service() {

    private var windowManager: WindowManager? = null
    private var overlayView: View? = null

    companion object {
        const val ACTION_SHOW_OVERLAY = "com.example.scrollguard.SHOW_OVERLAY"
        const val ACTION_HIDE_OVERLAY = "com.example.scrollguard.HIDE_OVERLAY"
    }

    private val overlayReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            when (intent?.action) {
                ACTION_SHOW_OVERLAY -> showOverlay()
                ACTION_HIDE_OVERLAY -> hideOverlay()
            }
        }
    }

    override fun onCreate() {
        super.onCreate()
        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
        
        val filter = IntentFilter().apply {
            addAction(ACTION_SHOW_OVERLAY)
            addAction(ACTION_HIDE_OVERLAY)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(overlayReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(overlayReceiver, filter)
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun showOverlay() {
        if (overlayView != null) return

        try {
            val params = WindowManager.LayoutParams(
                WindowManager.LayoutParams.MATCH_PARENT,
                WindowManager.LayoutParams.MATCH_PARENT,
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                    WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
                else
                    WindowManager.LayoutParams.TYPE_PHONE,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                        WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN or
                        WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
                PixelFormat.TRANSLUCENT
            )

            val context = this
            val layout = android.widget.FrameLayout(context)
            layout.setBackgroundColor(0xCC000000.toInt()) // Semi-transparent black

            val textView = android.widget.TextView(context)
            textView.text = "Time Limit Reached\nTap to Open ScrollGuard"
            textView.setTextColor(0xFFFFFFFF.toInt())
            textView.textSize = 24f
            textView.gravity = Gravity.CENTER
            
            val textParams = android.widget.FrameLayout.LayoutParams(
                android.widget.FrameLayout.LayoutParams.WRAP_CONTENT,
                android.widget.FrameLayout.LayoutParams.WRAP_CONTENT
            )
            textParams.gravity = Gravity.CENTER
            layout.addView(textView, textParams)
            
            layout.setOnClickListener {
                val activityIntent = Intent(context, MainActivity::class.java).apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
                    addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                    putExtra("route", "/intervention")
                }
                context.startActivity(activityIntent)
                hideOverlay()
            }

            windowManager?.addView(layout, params)
            overlayView = layout
            
        } catch (e: Exception) {
            e.printStackTrace()
            // Fallback to direct activity launch if overlay fails
             val activityIntent = Intent(this, MainActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
                putExtra("route", "/intervention")
            }
            startActivity(activityIntent)
        }
    }

    private fun hideOverlay() {
        if (overlayView != null) {
            try {
                windowManager?.removeView(overlayView)
            } catch (e: Exception) {
                // Ignore if view not attached
            }
            overlayView = null
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(overlayReceiver)
        hideOverlay()
    }
}
