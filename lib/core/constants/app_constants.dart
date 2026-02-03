/// App-wide constants for ScrollGuard
class AppConstants {
  AppConstants._();

  // ═══════════════════════════════════════════════════════════════════════════
  // APP INFO
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const String appName = 'ScrollGuard';
  static const String appTagline = 'Mindful moments for digital wellness';
  static const String appVersion = '1.0.0';

  // ═══════════════════════════════════════════════════════════════════════════
  // TIME LIMITS (in minutes)
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const List<int> timePresets = [1, 15, 30, 45, 60];
  static const int defaultTimeLimit = 30;
  
  // For testing (1 minute)
  static const int testTimeLimit = 1;

  // ═══════════════════════════════════════════════════════════════════════════
  // BREATHING EXERCISE
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Box breathing pattern (4-4-4-4)
  static const int breatheInhaleDuration = 4;
  static const int breatheHoldInDuration = 4;
  static const int breatheExhaleDuration = 4;
  static const int breatheHoldOutDuration = 4;
  
  /// Total cycles for full exercise
  static const int breatheCycles = 3;
  
  /// Minimum display time for intervention (Play Store safety)
  static const int minInterventionDisplaySeconds = 10;

  // ═══════════════════════════════════════════════════════════════════════════
  // GROUNDING EXERCISE (5-4-3-2-1)
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const int groundingSee = 5;
  static const int groundingTouch = 4;
  static const int groundingHear = 3;
  static const int groundingSmell = 2;
  static const int groundingTaste = 1;

  // ═══════════════════════════════════════════════════════════════════════════
  // ANIMATION DURATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  static const Duration overlayFadeIn = Duration(milliseconds: 2000);
  
  // Page transitions
  static const Duration pageTransition = Duration(milliseconds: 350);

  // ═══════════════════════════════════════════════════════════════════════════
  // SOCIAL MEDIA APPS (Package names for Android)
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const Map<String, String> socialApps = {
    'Instagram': 'com.instagram.android',
    'TikTok': 'com.zhiliaoapp.musically',
    'YouTube': 'com.google.android.youtube',
    'Facebook': 'com.facebook.katana',
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MESSAGES (Non-judgmental, calm language)
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const List<String> interventionMessages = [
    "Let's check in.",
    "Time for a mindful moment.",
    "Let's pause together.",
    "A moment of awareness.",
    "Let's take a breath.",
  ];
  
  static const List<String> motivationalMessages = [
    "You've been scrolling for a while.\nLet's pause for a moment.",
    "Your mind deserves a break.\nLet's breathe together.",
    "Awareness is the first step.\nYou're doing great.",
    "A gentle pause can make\nall the difference.",
    "Let's reset and refocus\nwith intention.",
  ];

  static const List<String> completionMessages = [
    "Well done. You chose awareness.",
    "That was beautiful. Keep going.",
    "You're building mindful habits.",
    "Every pause is progress.",
    "Your wellbeing matters.",
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // STORAGE KEYS
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyMonitoredApps = 'monitored_apps';
  static const String keyTimeLimit = 'time_limit';
  static const String keyHapticsEnabled = 'haptics_enabled';
  static const String keySoundsEnabled = 'sounds_enabled';
  static const String keyTodayUsage = 'today_usage';
  static const String keyInterventionCount = 'intervention_count';
}
