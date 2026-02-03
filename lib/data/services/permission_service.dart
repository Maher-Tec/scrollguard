import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

/// Centralized permission handling for ScrollGuard
class PermissionService {
  static const MethodChannel _channel = MethodChannel('com.maherahmed.scrollguard/permissions');

  /// Check if all required permissions are granted
  Future<bool> areAllPermissionsGranted() async {
    final usageStats = await isUsageStatsPermissionGranted();
    final overlay = await isOverlayPermissionGranted();
    final accessibility = await isAccessibilityServiceEnabled();
    
    return usageStats && overlay && accessibility;
  }

  /// Get status of all permissions
  Future<PermissionStatus> getPermissionStatus() async {
    return PermissionStatus(
      usageStats: await isUsageStatsPermissionGranted(),
      overlay: await isOverlayPermissionGranted(),
      accessibility: await isAccessibilityServiceEnabled(),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // USAGE STATS PERMISSION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Check if Usage Stats permission is granted
  Future<bool> isUsageStatsPermissionGranted() async {
    try {
      final result = await _channel.invokeMethod<bool>('isUsageStatsPermissionGranted');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Open Usage Stats settings
  Future<void> requestUsageStatsPermission() async {
    try {
      await _channel.invokeMethod('requestUsageStatsPermission');
    } on PlatformException {
      // Handle error silently
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // OVERLAY PERMISSION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Check if Overlay permission is granted
  Future<bool> isOverlayPermissionGranted() async {
    try {
      final result = await _channel.invokeMethod<bool>('isOverlayPermissionGranted');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Open Overlay settings
  Future<void> requestOverlayPermission() async {
    try {
      await _channel.invokeMethod('requestOverlayPermission');
    } on PlatformException {
      // Handle error silently
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ACCESSIBILITY SERVICE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Check if Accessibility Service is enabled
  Future<bool> isAccessibilityServiceEnabled() async {
    try {
      final result = await _channel.invokeMethod<bool>('isAccessibilityServiceEnabled');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Open Accessibility settings
  Future<void> openAccessibilitySettings() async {
    try {
      await _channel.invokeMethod('openAccessibilitySettings');
    } on PlatformException {
      // Handle error silently
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NOTIFICATION PERMISSION (Optional)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Request notification permission (Android 13+)
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }
}

/// Status of all required permissions
class PermissionStatus {
  final bool usageStats;
  final bool overlay;
  final bool accessibility;

  const PermissionStatus({
    required this.usageStats,
    required this.overlay,
    required this.accessibility,
  });

  bool get allGranted => usageStats && overlay && accessibility;

  int get grantedCount {
    int count = 0;
    if (usageStats) count++;
    if (overlay) count++;
    if (accessibility) count++;
    return count;
  }

  int get totalCount => 3;

  String get progressText => '$grantedCount / $totalCount permissions';
}
