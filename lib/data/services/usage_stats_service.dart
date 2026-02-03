import 'package:flutter/services.dart';

/// Service for interacting with Android UsageStats API
class UsageStatsService {
  static const MethodChannel _channel = MethodChannel('com.maherahmed.scrollguard/usage_stats');

  /// Get usage stats for specified apps in a time range
  /// Returns map of packageName -> usageMinutes
  Future<Map<String, int>> getUsageStats({
    required List<String> packageNames,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('getUsageStats', {
        'packageNames': packageNames,
        'start': startTime.millisecondsSinceEpoch,
        'end': endTime.millisecondsSinceEpoch,
      });
      
      if (result == null) return {};
      
      // Filter by requested packages and convert ms to minutes
      final stats = <String, int>{};
      for (final entry in result.entries) {
        final packageName = entry.key.toString();
        // Only include if in our monitored list
        if (packageNames.contains(packageName)) {
           final ms = (entry.value as num).toInt();
           // Convert milliseconds to minutes
           stats[packageName] = ms ~/ (1000 * 60);
        }
      }
      return stats;
    } on PlatformException {
      return {};
    }
  }

  /// Get today's usage for specified apps
  Future<Map<String, int>> getTodayUsage(List<String> packageNames) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    
    return getUsageStats(
      packageNames: packageNames,
      startTime: startOfDay,
      endTime: now,
    );
  }

  /// Get list of installed social media apps
  Future<List<InstalledApp>> getInstalledSocialApps() async {
    try {
      final result = await _channel.invokeMethod<List<dynamic>>('getInstalledSocialApps');
      
      if (result == null) return [];
      
      return result.map((item) {
        final map = item as Map<dynamic, dynamic>;
        return InstalledApp(
          name: map['name'] as String,
          packageName: map['packageName'] as String,
        );
      }).toList();
    } on PlatformException {
      return [];
    }
  }

  /// Start monitoring specified apps
  Future<bool> startMonitoring({
    required List<String> packageNames,
    required int timeLimitMinutes,
    required Map<String, int> baselines,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>('startMonitoring', {
        'packageNames': packageNames,
        'timeLimitMinutes': timeLimitMinutes,
        'baselines': baselines,
      });
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Stop monitoring
  Future<bool> stopMonitoring() async {
    try {
      final result = await _channel.invokeMethod<bool>('stopMonitoring');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Get current session duration in minutes
  Future<int> getCurrentSessionMinutes() async {
    try {
      final result = await _channel.invokeMethod<int>('getCurrentSessionMinutes');
      return result ?? 0;
    } on PlatformException {
      return 0;
    }
  }

  /// Check if monitoring is active
  Future<bool> isMonitoringActive() async {
    try {
      final result = await _channel.invokeMethod<bool>('isMonitoringActive');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Show intervention overlay
  Future<void> showInterventionOverlay() async {
    try {
      await _channel.invokeMethod('showInterventionOverlay');
    } on PlatformException {
      // Handle error silently
    }
  }

  /// Hide intervention overlay
  Future<void> hideInterventionOverlay() async {
    try {
      await _channel.invokeMethod('hideInterventionOverlay');
    } on PlatformException {
      // Handle error silently
    }
  }
}

/// Represents an installed app
class InstalledApp {
  final String name;
  final String packageName;

  const InstalledApp({
    required this.name,
    required this.packageName,
  });
}
