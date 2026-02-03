/// Represents a single usage session for a monitored app
class UsageEntry {
  final String packageName;
  final String appName;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;

  const UsageEntry({
    required this.packageName,
    required this.appName,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
  });

  factory UsageEntry.fromDuration({
    required String packageName,
    required String appName,
    required int durationMinutes,
  }) {
    final now = DateTime.now();
    return UsageEntry(
      packageName: packageName,
      appName: appName,
      startTime: now.subtract(Duration(minutes: durationMinutes)),
      endTime: now,
      durationMinutes: durationMinutes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'appName': appName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'durationMinutes': durationMinutes,
    };
  }

  factory UsageEntry.fromJson(Map<String, dynamic> json) {
    return UsageEntry(
      packageName: json['packageName'] as String,
      appName: json['appName'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      durationMinutes: json['durationMinutes'] as int,
    );
  }

  @override
  String toString() => 'UsageEntry($appName: ${durationMinutes}min)';
}

/// Daily usage summary
class DailyUsage {
  final DateTime date;
  final int totalMinutes;
  final int interventionCount;
  final Map<String, int> appUsage; // packageName -> minutes

  const DailyUsage({
    required this.date,
    required this.totalMinutes,
    required this.interventionCount,
    required this.appUsage,
  });

  factory DailyUsage.empty() {
    return DailyUsage(
      date: DateTime.now(),
      totalMinutes: 0,
      interventionCount: 0,
      appUsage: const {},
    );
  }

  DailyUsage copyWith({
    DateTime? date,
    int? totalMinutes,
    int? interventionCount,
    Map<String, int>? appUsage,
  }) {
    return DailyUsage(
      date: date ?? this.date,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      interventionCount: interventionCount ?? this.interventionCount,
      appUsage: appUsage ?? this.appUsage,
    );
  }

  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String get formattedDuration {
    if (totalMinutes < 60) {
      return '${totalMinutes}m';
    }
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'totalMinutes': totalMinutes,
      'interventionCount': interventionCount,
      'appUsage': appUsage,
    };
  }

  factory DailyUsage.fromJson(Map<String, dynamic> json) {
    return DailyUsage(
      date: DateTime.parse(json['date'] as String),
      totalMinutes: json['totalMinutes'] as int,
      interventionCount: json['interventionCount'] as int,
      appUsage: Map<String, int>.from(json['appUsage'] as Map),
    );
  }
}
