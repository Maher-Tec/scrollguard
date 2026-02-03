/// Represents a social media app that can be monitored
class MonitoredApp {
  final String name;
  final String packageName;
  final bool isEnabled;

  const MonitoredApp({
    required this.name,
    required this.packageName,
    this.isEnabled = false,
  });

  MonitoredApp copyWith({
    String? name,
    String? packageName,
    bool? isEnabled,
  }) {
    return MonitoredApp(
      name: name ?? this.name,
      packageName: packageName ?? this.packageName,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'packageName': packageName,
      'isEnabled': isEnabled,
    };
  }

  factory MonitoredApp.fromJson(Map<String, dynamic> json) {
    return MonitoredApp(
      name: json['name'] as String,
      packageName: json['packageName'] as String,
      isEnabled: json['isEnabled'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MonitoredApp && other.packageName == packageName;
  }

  @override
  int get hashCode => packageName.hashCode;

  @override
  String toString() => 'MonitoredApp(name: $name, packageName: $packageName, isEnabled: $isEnabled)';
}

/// Default list of social apps to monitor
class DefaultApps {
  static const List<MonitoredApp> all = [
    MonitoredApp(
      name: 'Instagram',
      packageName: 'com.instagram.android',
    ),
    MonitoredApp(
      name: 'TikTok',
      packageName: 'com.zhiliaoapp.musically',
    ),
    MonitoredApp(
      name: 'YouTube',
      packageName: 'com.google.android.youtube',
    ),
    MonitoredApp(
      name: 'Facebook',
      packageName: 'com.facebook.katana',
    ),
  ];
}
