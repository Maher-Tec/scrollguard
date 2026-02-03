import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usage_entry.dart';

/// Repository for persisting and loading usage data
class UsageRepository {
  static const String _todayUsageKey = 'today_usage';
  static const String _interventionCountKey = 'intervention_count';
  static const String _lastResetKey = 'last_reset_date';
  static const String _baselineUsageKey = 'baseline_usage';
  
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Check if we need to reset daily data
  Future<bool> _shouldResetDaily() async {
    final prefs = await _preferences;
    final lastReset = prefs.getString(_lastResetKey);
    
    if (lastReset == null) return true;
    
    final lastResetDate = DateTime.parse(lastReset);
    final now = DateTime.now();
    
    return lastResetDate.year != now.year ||
           lastResetDate.month != now.month ||
           lastResetDate.day != now.day;
  }

  /// Reset daily data if needed
  Future<void> _resetDailyIfNeeded() async {
    if (await _shouldResetDaily()) {
      final prefs = await _preferences;
      await prefs.remove(_todayUsageKey);
      await prefs.remove(_interventionCountKey);
      await prefs.remove(_baselineUsageKey);
      await prefs.setString(_lastResetKey, DateTime.now().toIso8601String());
    }
  }

  /// Get today's usage data
  Future<DailyUsage> getTodayUsage() async {
    await _resetDailyIfNeeded();
    
    try {
      final prefs = await _preferences;
      final jsonString = prefs.getString(_todayUsageKey);
      final interventionCount = prefs.getInt(_interventionCountKey) ?? 0;
      
      if (jsonString == null) {
        return DailyUsage(
          date: DateTime.now(),
          totalMinutes: 0,
          interventionCount: interventionCount,
          appUsage: const {},
        );
      }
      
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return DailyUsage.fromJson(json).copyWith(
        interventionCount: interventionCount,
      );
    } catch (e) {
      return DailyUsage.empty();
    }
  }

  /// Save today's usage data
  Future<bool> saveTodayUsage(DailyUsage usage) async {
    try {
      final prefs = await _preferences;
      final jsonString = jsonEncode(usage.toJson());
      await prefs.setString(_todayUsageKey, jsonString);
      await prefs.setInt(_interventionCountKey, usage.interventionCount);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Save baseline usage (snapshot of usage when protection starts)
  Future<void> saveBaseline(Map<String, int> usage) async {
    final prefs = await _preferences;
    await prefs.setString(_baselineUsageKey, jsonEncode(usage));
  }

  /// Get baseline usage
  Future<Map<String, int>> getBaseline() async {
    await _resetDailyIfNeeded();
    final prefs = await _preferences;
    final jsonString = prefs.getString(_baselineUsageKey);
    
    if (jsonString == null) return {};
    
    try {
      return Map<String, int>.from(jsonDecode(jsonString));
    } catch (_) {
      return {};
    }
  }

  /// Clear baseline usage (if user wants to revert to true daily total)
  Future<void> clearBaseline() async {
    final prefs = await _preferences;
    await prefs.remove(_baselineUsageKey);
  }

  /// Add usage time for an app
  Future<DailyUsage> addUsageTime({
    required String packageName,
    required String appName,
    required int minutes,
  }) async {
    final current = await getTodayUsage();
    
    final newAppUsage = Map<String, int>.from(current.appUsage);
    newAppUsage[packageName] = (newAppUsage[packageName] ?? 0) + minutes;
    
    final newTotal = current.totalMinutes + minutes;
    
    final updated = current.copyWith(
      totalMinutes: newTotal,
      appUsage: newAppUsage,
    );
    
    await saveTodayUsage(updated);
    return updated;
  }

  /// Increment intervention count
  Future<int> incrementInterventionCount() async {
    await _resetDailyIfNeeded();
    
    final prefs = await _preferences;
    final current = prefs.getInt(_interventionCountKey) ?? 0;
    final newCount = current + 1;
    await prefs.setInt(_interventionCountKey, newCount);
    return newCount;
  }

  int _currentSessionMinutes = 0;
  int get currentSessionMinutes => _currentSessionMinutes;

  void updateCurrentSession(int minutes) {
    _currentSessionMinutes = minutes;
  }

  void resetCurrentSession() {
    _currentSessionMinutes = 0;
  }

  /// Clear all usage data (for testing/reset)
  Future<bool> clearUsageData() async {
    try {
      final prefs = await _preferences;
      await prefs.remove(_todayUsageKey);
      await prefs.remove(_interventionCountKey);
      await prefs.remove(_lastResetKey);
      await prefs.remove(_baselineUsageKey);
      return true;
    } catch (e) {
      return false;
    }
  }
}
