package com.example.scrollguard

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.view.accessibility.AccessibilityEvent
import android.util.Log

/**
 * ScrollGuard Accessibility Service
 * 
 * This service detects which app is currently in the foreground and
 * triggers interventions if usage limits are exceeded.
 */
class ScrollGuardAccessibilityService : AccessibilityService() {

    companion object {
        private const val TAG = "ScrollGuardAccess"
        var currentPackageName: String? = null
        var isServiceRunning = false

        // Settings
        private var monitoredPackages = listOf<String>()
        private var timeLimitMinutes = 30
        private var isMonitoringActive = false
        
        // Precise Local Tracking
        private var sessionStartTime = 0L
        private var totalUsageSinceSessionStartMs = 0L
        private var lastForegroundTimestamp = 0L

        fun updateMonitoringSettings(packages: List<String>, limit: Int, currentBaselines: Map<String, Int>) {
            val wasActive = isMonitoringActive
            
            monitoredPackages = packages
            timeLimitMinutes = limit
            isMonitoringActive = true
            
            
            // Calculate initial usage from baselines (which now contain effective session usage from Flutter)
            var initialUsageMs = 0L
            for (pkg in packages) {
                val minutes = currentBaselines[pkg] ?: 0
                initialUsageMs += minutes * 60 * 1000L
            }
            
            // Always update our local counter to match Flutter's truth
            totalUsageSinceSessionStartMs = initialUsageMs
            
            if (!wasActive) {
                sessionStartTime = System.currentTimeMillis()
                lastForegroundTimestamp = System.currentTimeMillis() 
                Log.d(TAG, "STARTED NEW SESSION: limit=$limit min, initialUsage=${initialUsageMs}ms, packages=$packages")
            } else {
                 Log.d(TAG, "UPDATED SESSION: limit=$limit min, initialUsage=${initialUsageMs}ms")
            }
        }

        fun stopMonitoring() {
            isMonitoringActive = false
            totalUsageSinceSessionStartMs = 0L
        }
    }

    private val checkHandler = Handler(Looper.getMainLooper())
    private val checkRunnable = object : Runnable {
        override fun run() {
            if (isMonitoringActive && isMonitoredApp(currentPackageName)) {
                checkUsagePrecise()
                // Check frequently (every 1 second) for instant feedback
                checkHandler.postDelayed(this, 1000) 
            }
        }
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        event?.let {
            if (it.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
                val newPackageName = it.packageName?.toString()
                
                if (newPackageName != null && newPackageName != currentPackageName) {
                    val now = System.currentTimeMillis()
                    
                    // 1. If previous app was monitored, add its duration to total
                    if (isMonitoringActive && isMonitoredApp(currentPackageName)) {
                        val duration = now - lastForegroundTimestamp
                        if (duration > 0) {
                            totalUsageSinceSessionStartMs += duration
                        }
                    }
                    
                    // 2. Update state
                    currentPackageName = newPackageName
                    lastForegroundTimestamp = now
                    
                    // 3. If new app is monitored, start checking
                    if (isMonitoringActive && isMonitoredApp(newPackageName)) {
                        Log.d(TAG, "Entered monitored app: $newPackageName")
                        checkHandler.removeCallbacks(checkRunnable)
                        checkHandler.post(checkRunnable)
                    } else {
                        checkHandler.removeCallbacks(checkRunnable)
                    }
                }
            }
        }
    }

    private fun isMonitoredApp(packageName: String?): Boolean {
        return packageName != null && monitoredPackages.contains(packageName)
    }

    private fun checkUsagePrecise() {
        val now = System.currentTimeMillis()
        
        // Calculate accrued time in current session (since last app switch)
        val currentSessionDuration = now - lastForegroundTimestamp
        val totalEffectiveMs = totalUsageSinceSessionStartMs + currentSessionDuration
        
        val totalEffectiveMinutes = (totalEffectiveMs / (1000 * 60)).toInt()
        
        // Log periodically (every ~30s or when minute changes) to avoid spam
        if (totalEffectiveMs % 10000 < 1100) { 
             Log.d(TAG, "Precise Tracker: ${totalEffectiveMs}ms / ${timeLimitMinutes * 60 * 1000}ms")
        }

        if (totalEffectiveMinutes >= timeLimitMinutes) {
            triggerIntervention()
        }
    }

    private fun triggerIntervention() {
        Log.d(TAG, "LIMIT REACHED! Triggering intervention.")
        
        // Vibrate to give immediate physical feedback
        val vibrator = getSystemService(Context.VIBRATOR_SERVICE) as android.os.Vibrator
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            vibrator.vibrate(android.os.VibrationEffect.createOneShot(500, android.os.VibrationEffect.DEFAULT_AMPLITUDE))
        } else {
            vibrator.vibrate(500)
        }

        // Launch Overlay Service (Guaranteed implementation for background starts)
        val intent = Intent(this, OverlayService::class.java).apply {
            action = OverlayService.ACTION_SHOW_OVERLAY
        }
        startService(intent)
        
        // Stop checking to prevent spamming opens
        checkHandler.removeCallbacks(checkRunnable)
    }

    override fun onInterrupt() {
        isServiceRunning = false
    }

    override fun onDestroy() {
        super.onDestroy()
        isServiceRunning = false
        currentPackageName = null
        checkHandler.removeCallbacks(checkRunnable)
    }
}
