package com.example.scrollguard

import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.os.IBinder
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.LinearLayout
import android.widget.TextView

class OverlayService : Service() {

    private var windowManager: WindowManager? = null
    private var overlayView: View? = null

    companion object {
        const val ACTION_SHOW_OVERLAY = "com.example.scrollguard.SHOW_OVERLAY"
        const val ACTION_HIDE_OVERLAY = "com.example.scrollguard.HIDE_OVERLAY"
    }

    override fun onCreate() {
        super.onCreate()
        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_SHOW_OVERLAY -> showOverlay()
            ACTION_HIDE_OVERLAY -> {
                hideOverlay()
                stopSelf()
            }
        }
        return START_NOT_STICKY
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
            layout.setBackgroundColor(0xB3000000.toInt())
            val density = resources.displayMetrics.density
            fun dp(value: Int) = (value * density).toInt()

            val card = LinearLayout(context).apply {
                orientation = LinearLayout.VERTICAL
                gravity = Gravity.CENTER
                setPadding(dp(24), dp(28), dp(24), dp(24))
                background = GradientDrawable().apply {
                    setColor(Color.rgb(32, 40, 48))
                    cornerRadius = dp(24).toFloat()
                    setStroke(dp(1), Color.rgb(91, 115, 121))
                }
            }
            val title = TextView(context).apply {
                text = "Time for a pause"
                textSize = 24f
                setTextColor(Color.WHITE)
                typeface = Typeface.DEFAULT_BOLD
                gravity = Gravity.CENTER
            }
            val subtitle = TextView(context).apply {
                text = "Your screen time limit is reached."
                textSize = 15f
                setTextColor(Color.rgb(191, 203, 207))
                gravity = Gravity.CENTER
                setPadding(0, dp(10), 0, dp(22))
            }
            val button = TextView(context).apply {
                text = "Open ScrollGuard"
                textSize = 17f
                typeface = Typeface.DEFAULT_BOLD
                setTextColor(Color.rgb(15, 31, 33))
                gravity = Gravity.CENTER
                background = GradientDrawable().apply {
                    setColor(Color.rgb(116, 219, 203))
                    cornerRadius = dp(14).toFloat()
                }
            }
            card.addView(title)
            card.addView(subtitle)
            card.addView(button, LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, dp(52)
            ))
            layout.addView(card, android.widget.FrameLayout.LayoutParams(
                android.widget.FrameLayout.LayoutParams.MATCH_PARENT,
                android.widget.FrameLayout.LayoutParams.WRAP_CONTENT,
                Gravity.CENTER
            ).apply { marginStart = dp(24); marginEnd = dp(24) })
            
            layout.setOnClickListener {
                val activityIntent = Intent(context, MainActivity::class.java).apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
                    addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                    putExtra("route", "/intervention")
                }
                context.startActivity(activityIntent)
                hideOverlay()
                stopSelf()
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
        hideOverlay()
    }
}
