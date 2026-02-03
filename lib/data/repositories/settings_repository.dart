import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/monitored_app.dart';
import '../models/user_settings.dart';

/// Repository for persisting and loading user settings
class SettingsRepository {
  static const String _settingsKey = 'user_settings';
  
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Load user settings from storage
  Future<UserSettings> loadSettings() async {
    try {
      final prefs = await _preferences;
      final jsonString = prefs.getString(_settingsKey);
      
      if (jsonString == null) {
        // Return default settings with pre-populated apps
        return UserSettings(
          monitoredApps: DefaultApps.all,
        );
      }
      
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserSettings.fromJson(json);
    } catch (e) {
      // Return default settings on error
      return UserSettings(
        monitoredApps: DefaultApps.all,
      );
    }
  }

  /// Save user settings to storage
  Future<bool> saveSettings(UserSettings settings) async {
    try {
      final prefs = await _preferences;
      final jsonString = jsonEncode(settings.toJson());
      return await prefs.setString(_settingsKey, jsonString);
    } catch (e) {
      return false;
    }
  }

  /// Mark onboarding as complete
  Future<bool> completeOnboarding(UserSettings settings) async {
    final updatedSettings = settings.copyWith(onboardingComplete: true);
    return saveSettings(updatedSettings);
  }

  /// Update monitored apps
  Future<bool> updateMonitoredApps(
    UserSettings settings,
    List<MonitoredApp> apps,
  ) async {
    final updatedSettings = settings.copyWith(monitoredApps: apps);
    return saveSettings(updatedSettings);
  }

  /// Update time limit
  Future<bool> updateTimeLimit(
    UserSettings settings,
    int minutes,
  ) async {
    final updatedSettings = settings.copyWith(timeLimitMinutes: minutes);
    return saveSettings(updatedSettings);
  }

  /// Toggle haptics
  Future<bool> toggleHaptics(UserSettings settings, bool enabled) async {
    final updatedSettings = settings.copyWith(hapticsEnabled: enabled);
    return saveSettings(updatedSettings);
  }

  /// Toggle sounds
  Future<bool> toggleSounds(UserSettings settings, bool enabled) async {
    final updatedSettings = settings.copyWith(soundsEnabled: enabled);
    return saveSettings(updatedSettings);
  }

  /// Toggle monitoring active
  Future<bool> toggleMonitoring(UserSettings settings, bool active) async {
    final updatedSettings = settings.copyWith(monitoringActive: active);
    return saveSettings(updatedSettings);
  }

  /// Clear all settings (for testing/reset)
  Future<bool> clearSettings() async {
    try {
      final prefs = await _preferences;
      return await prefs.remove(_settingsKey);
    } catch (e) {
      return false;
    }
  }
}
