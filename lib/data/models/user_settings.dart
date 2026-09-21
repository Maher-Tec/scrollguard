import 'package:flutter/material.dart';
import 'monitored_app.dart';
import 'intervention_mode.dart';

/// User preferences and settings
class UserSettings {
  final bool onboardingComplete;
  final List<MonitoredApp> monitoredApps;
  final int timeLimitMinutes;
  final bool hapticsEnabled;
  final bool soundsEnabled;
  final bool monitoringActive;
  final InterventionMode interventionMode;
  final ThemeMode themeMode;

  const UserSettings({
    this.onboardingComplete = false,
    this.monitoredApps = const [],
    this.timeLimitMinutes = 30,
    this.hapticsEnabled = true,
    this.soundsEnabled = true,
    this.monitoringActive = false,
    this.interventionMode = InterventionMode.breathing,
    this.themeMode = ThemeMode.dark,
  });

  UserSettings copyWith({
    bool? onboardingComplete,
    List<MonitoredApp>? monitoredApps,
    int? timeLimitMinutes,
    bool? hapticsEnabled,
    bool? soundsEnabled,
    bool? monitoringActive,
    InterventionMode? interventionMode,
    ThemeMode? themeMode,
  }) {
    return UserSettings(
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      monitoredApps: monitoredApps ?? this.monitoredApps,
      timeLimitMinutes: timeLimitMinutes ?? this.timeLimitMinutes,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      soundsEnabled: soundsEnabled ?? this.soundsEnabled,
      monitoringActive: monitoringActive ?? this.monitoringActive,
      interventionMode: interventionMode ?? this.interventionMode,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  /// Get only enabled apps
  List<MonitoredApp> get enabledApps {
    return monitoredApps.where((app) => app.isEnabled).toList();
  }

  /// Get package names of enabled apps
  List<String> get enabledPackages {
    return enabledApps.map((app) => app.packageName).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'onboardingComplete': onboardingComplete,
      'monitoredApps': monitoredApps.map((app) => app.toJson()).toList(),
      'timeLimitMinutes': timeLimitMinutes,
      'hapticsEnabled': hapticsEnabled,
      'soundsEnabled': soundsEnabled,
      'monitoringActive': monitoringActive,
      'interventionMode': interventionMode.name,
      'themeMode': themeMode.name,
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      monitoredApps: (json['monitoredApps'] as List<dynamic>?)
              ?.map((e) => MonitoredApp.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      timeLimitMinutes: json['timeLimitMinutes'] as int? ?? 30,
      hapticsEnabled: json['hapticsEnabled'] as bool? ?? true,
      soundsEnabled: json['soundsEnabled'] as bool? ?? true,
      monitoringActive: json['monitoringActive'] as bool? ?? false,
      interventionMode: InterventionMode.values.firstWhere(
        (mode) => mode.name == json['interventionMode'],
        orElse: () => InterventionMode.breathing,
      ),
      themeMode: ThemeMode.values.firstWhere(
        (mode) => mode.name == json['themeMode'],
        orElse: () => ThemeMode.dark,
      ),
    );
  }

  @override
  String toString() {
    return 'UserSettings(onboardingComplete: $onboardingComplete, apps: ${monitoredApps.length}, limit: ${timeLimitMinutes}min, theme: ${themeMode.name})';
  }
}
