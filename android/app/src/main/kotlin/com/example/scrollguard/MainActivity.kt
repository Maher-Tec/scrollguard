package com.example.scrollguard

import android.app.AppOpsManager
import android.app.usage.UsageStats
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Process
import android.provider.Settings
import android.accessibilityservice.AccessibilityServiceInfo
import android.view.accessibility.AccessibilityManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar

class MainActivity : FlutterActivity() {
    private val PERMISSIONS_CHANNEL = "com.maherahmed.scrollguard/permissions"
    private val USAGE_STATS_CHANNEL = "com.maherahmed.scrollguard/usage_stats"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Handle initial route if launched from OverlayService
        val route = intent.getStringExtra("route")
        if (route != null) {
            flutterEngine.navigationChannel.pushRoute(route)
        }
        
        // Permissions Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PERMISSIONS_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "isUsageStatsPermissionGranted" -> {
                    result.success(isUsageStatsPermissionGranted())
                }
                "isOverlayPermissionGranted" -> {
                    result.success(isOverlayPermissionGranted())
                }
                "isAccessibilityServiceEnabled" -> {
                    result.success(isAccessibilityServiceEnabled())
                }
                "requestUsageStatsPermission" -> {
                    requestUsageStatsPermission()
                    result.success(null)
                }
                "requestOverlayPermission" -> {
                    requestOverlayPermission()
                    result.success(null)
                }
                "openAccessibilitySettings" -> {
                    openAccessibilitySettings()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
        
        // Usage Stats Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, USAGE_STATS_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getUsageStats" -> {
                    val start = call.argument<Long>("start") ?: 0L
                    val end = call.argument<Long>("end") ?: System.currentTimeMillis()
                    result.success(getUsageStats(start, end))
                }
                "getInstalledSocialApps" -> {
                    result.success(getInstalledSocialApps())
                }
                "startMonitoring" -> {
                    val packageNames = call.argument<List<String>>("packageNames") ?: emptyList()
                    val limitMinutes = call.argument<Int>("timeLimitMinutes") ?: 30
                    val baselines = call.argument<Map<String, Int>>("baselines") ?: emptyMap()
                    
                    ScrollGuardAccessibilityService.updateMonitoringSettings(
                        packageNames,
                        limitMinutes,
                        baselines
                    )
                    result.success(isAccessibilityServiceEnabled())
                }
                "stopMonitoring" -> {
                    ScrollGuardAccessibilityService.stopMonitoring()
                    result.success(true)
                }
                "showInterventionOverlay" -> {
                    showOverlay()
                    result.success(null)
                }
                "hideInterventionOverlay" -> {
                    hideOverlay()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val route = intent.getStringExtra("route")
        if (route != null) {
            flutterEngine?.navigationChannel?.pushRoute(route)
        }
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // PERMISSION CHECKS
    // ═══════════════════════════════════════════════════════════════════════════

    private fun isUsageStatsPermissionGranted(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                Process.myUid(),
                packageName
            )
        } else {
            @Suppress("DEPRECATION")
            appOps.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                Process.myUid(),
                packageName
            )
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun isOverlayPermissionGranted(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Settings.canDrawOverlays(this)
        } else {
            true
        }
    }

    private fun isAccessibilityServiceEnabled(): Boolean {
        val am = getSystemService(Context.ACCESSIBILITY_SERVICE) as AccessibilityManager
        val enabledServices = am.getEnabledAccessibilityServiceList(AccessibilityServiceInfo.FEEDBACK_ALL_MASK)
        for (service in enabledServices) {
            if (service.resolveInfo.serviceInfo.packageName == packageName) {
                return true
            }
        }
        return false
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // PERMISSION REQUESTS
    // ═══════════════════════════════════════════════════════════════════════════

    private fun requestUsageStatsPermission() {
        try {
            val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
            intent.data = Uri.parse("package:$packageName")
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            startActivity(intent)
        } catch (e: Exception) {
            val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            startActivity(intent)
        }
    }

    private fun requestOverlayPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName")
            )
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            startActivity(intent)
        }
    }

    private fun openAccessibilitySettings() {
        val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        startActivity(intent)
    }
    
    // ═══════════════════════════════════════════════════════════════════════════
    // USAGE STATS
    // ═══════════════════════════════════════════════════════════════════════════
    
    private fun getUsageStats(start: Long, end: Long): Map<String, Long> {
        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val stats = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY,
            start,
            end
        )

        val result = mutableMapOf<String, Long>()
        if (stats != null) {
            for (usageStat in stats) {
                if (usageStat.totalTimeInForeground > 0) {
                    // Aggregate if multiple entries exist for same package
                    val current = result[usageStat.packageName] ?: 0L
                    result[usageStat.packageName] = current + usageStat.totalTimeInForeground
                }
            }
        }
        return result
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // SOCIAL APPS
    // ═══════════════════════════════════════════════════════════════════════════

    private fun getInstalledSocialApps(): List<Map<String, Any>> {
        val socialPackages = listOf(
            "com.instagram.android",
            "com.zhiliaoapp.musically", // TikTok
            "com.ss.android.ugc.trill", // TikTok (alternate)
            "com.google.android.youtube",
            "com.facebook.katana",
            "com.twitter.android",
            "com.snapchat.android"
        )
        
        val installedApps = mutableListOf<Map<String, Any>>()
        val pm = packageManager
        
        for (packageName in socialPackages) {
            try {
                val appInfo = pm.getApplicationInfo(packageName, 0)
                val appName = pm.getApplicationLabel(appInfo).toString()
                installedApps.add(mapOf(
                    "name" to appName,
                    "packageName" to packageName
                ))
            } catch (e: Exception) {
                // App not installed, skip
            }
        }
        
        return installedApps
    }
    
    // ═══════════════════════════════════════════════════════════════════════════
    // OVERLAY ACTIONS
    // ═══════════════════════════════════════════════════════════════════════════
    
    private fun showOverlay() {
        val intent = Intent(this, OverlayService::class.java).apply {
            action = OverlayService.ACTION_SHOW_OVERLAY
        }
        startService(intent)
    }
    
    private fun hideOverlay() {
        val intent = Intent(this, OverlayService::class.java).apply {
            action = OverlayService.ACTION_HIDE_OVERLAY
        }
        startService(intent)
    }
}
