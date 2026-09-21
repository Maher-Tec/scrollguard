enum InterventionMode { breathing, dhikr, both }

extension InterventionModeLabel on InterventionMode {
  String get label => switch (this) {
        InterventionMode.breathing => 'Breathing',
        InterventionMode.dhikr => 'Dhikr',
        InterventionMode.both => 'Both',
      };
}
