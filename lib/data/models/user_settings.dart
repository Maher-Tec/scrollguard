import 'monitored_app.dart';

/// User preferences and settings
class UserSettings {
  final bool onboardingComplete;
  final List<MonitoredApp> monitoredApps;
  final int timeLimitMinutes;
  final bool hapticsEnabled;
  final bool soundsEnabled;
  final bool monitoringActive;

  const UserSettings({
    this.onboardingComplete = false,
    this.monitoredApps = const [],
    this.timeLimitMinutes = 30,
    this.hapticsEnabled = true,
    this.soundsEnabled = true,
    this.monitoringActive = false,
  });

  UserSettings copyWith({
    bool? onboardingComplete,
    List<MonitoredApp>? monitoredApps,
    int? timeLimitMinutes,
    bool? hapticsEnabled,
    bool? soundsEnabled,
    bool? monitoringActive,
  }) {
    return UserSettings(
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      monitoredApps: monitoredApps ?? this.monitoredApps,
      timeLimitMinutes: timeLimitMinutes ?? this.timeLimitMinutes,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      soundsEnabled: soundsEnabled ?? this.soundsEnabled,
      monitoringActive: monitoringActive ?? this.monitoringActive,
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
    );
  }

  @override
  String toString() {
    return 'UserSettings(onboardingComplete: $onboardingComplete, apps: ${monitoredApps.length}, limit: ${timeLimitMinutes}min)';
  }
}
