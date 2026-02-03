/// Types of intervention exercises
enum InterventionType {
  breathing,
  grounding,
  awareness,
}

extension InterventionTypeExtension on InterventionType {
  String get displayName {
    switch (this) {
      case InterventionType.breathing:
        return 'Breathe';
      case InterventionType.grounding:
        return 'Ground';
      case InterventionType.awareness:
        return 'Continue';
    }
  }

  String get description {
    switch (this) {
      case InterventionType.breathing:
        return 'Box breathing exercise\n4 seconds each phase';
      case InterventionType.grounding:
        return '5-4-3-2-1 senses exercise\nConnect with the present';
      case InterventionType.awareness:
        return 'I\'m aware of my time\nContinue with intention';
    }
  }

  String get icon {
    switch (this) {
      case InterventionType.breathing:
        return '😮‍💨';
      case InterventionType.grounding:
        return '🧘';
      case InterventionType.awareness:
        return '💡';
    }
  }

  /// Duration in seconds for the exercise
  int get durationSeconds {
    switch (this) {
      case InterventionType.breathing:
        return 48; // 3 cycles × 16 seconds each
      case InterventionType.grounding:
        return 60;
      case InterventionType.awareness:
        return 10; // Minimum display time
    }
  }
}

/// Phases of box breathing
enum BreathingPhase {
  inhale,
  holdIn,
  exhale,
  holdOut,
}

extension BreathingPhaseExtension on BreathingPhase {
  String get instruction {
    switch (this) {
      case BreathingPhase.inhale:
        return 'Breathe in';
      case BreathingPhase.holdIn:
        return 'Hold';
      case BreathingPhase.exhale:
        return 'Breathe out';
      case BreathingPhase.holdOut:
        return 'Hold';
    }
  }

  int get durationSeconds => 4;

  BreathingPhase get next {
    switch (this) {
      case BreathingPhase.inhale:
        return BreathingPhase.holdIn;
      case BreathingPhase.holdIn:
        return BreathingPhase.exhale;
      case BreathingPhase.exhale:
        return BreathingPhase.holdOut;
      case BreathingPhase.holdOut:
        return BreathingPhase.inhale;
    }
  }
}
