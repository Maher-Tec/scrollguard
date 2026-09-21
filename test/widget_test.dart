import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:scrollguard/features/dashboard/screens/dashboard_screen.dart';
import 'package:scrollguard/features/dashboard/widgets/mindful_practices_card.dart';
import 'package:scrollguard/features/dashboard/widgets/quick_stats.dart';
import 'package:scrollguard/features/dashboard/widgets/daily_dhikr_banner.dart';
import 'package:scrollguard/features/settings/screens/settings_screen.dart';
import 'package:scrollguard/data/models/usage_entry.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Dashboard renders Dhikr and Mindful practices', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );

    // Initial pump
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    // Verify key sanctuary sections are present
    expect(find.byType(MindfulPracticesSection), findsOneWidget);
    expect(find.text('ScrollGuard'), findsOneWidget);
    expect(find.text('Dhikr'), findsWidgets);
    expect(find.text('4-4-4-4 Box Breathing'), findsWidgets);
    expect(find.text('Take a moment'), findsOneWidget);
  });

  testWidgets('QuickStatsRow displays Dhikr along with screen time', (WidgetTester tester) async {
    final dailyUsage = DailyUsage(
      date: DateTime(2026, 9, 18),
      totalMinutes: 15,
      interventionCount: 2,
      appUsage: const {},
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: QuickStatsRow(usage: AsyncValue.data(dailyUsage)),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Pauses today'), findsOneWidget);
    expect(find.text('Dhikr taps'), findsOneWidget);
    expect(find.text('2 sessions'), findsOneWidget);
  });

  testWidgets('SettingsScreen renders Sanctuary Sovereignty deck and controls', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );

    // Initial pump and async load
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Header Deck & Section Titles
    expect(find.text('Sanctuary Settings'), findsOneWidget);
    expect(find.text('SOVEREIGNTY DECK'), findsOneWidget);
    expect(find.text('CONSCIOUS FRICTION ENGINE'), findsOneWidget);
    expect(find.text('SESSION THRESHOLD'), findsOneWidget);
    expect(find.text('PERIMETER APPS'), findsOneWidget);
    expect(find.text('PAUSE ACTIVITY PROTOCOL'), findsOneWidget);
    expect(find.text('SOMATIC SENSORY CONTROLS'), findsOneWidget);
    expect(find.text('SYSTEM SOVEREIGNTY'), findsOneWidget);

    // Verify Pause Activity Protocol options
    expect(find.text('Dhikr only'), findsOneWidget);
    expect(find.text('Breathing only'), findsOneWidget);
    expect(find.text('Both (Dhikr & Breathing)'), findsOneWidget);
    expect(find.text('HARMONY'), findsOneWidget);

    // Tap Dhikr only option
    await tester.tap(find.text('Dhikr only'));
    await tester.pump(const Duration(milliseconds: 200));

    // Tap a preset
    await tester.tap(find.text('1 min Fast Zen'));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('1m'), findsWidgets);
  });

  testWidgets('SettingsScreen appearance protocol toggles between Dark and Light themes', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Appearance & Theme Protocol section exists
    expect(find.text('APPEARANCE & THEME'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);

    // Tap Light mode
    await tester.tap(find.text('Light'));
    await tester.pump(const Duration(milliseconds: 200));

    // Tap Dark mode
    await tester.tap(find.text('Dark'));
    await tester.pump(const Duration(milliseconds: 200));

    // Tap System mode
    await tester.tap(find.text('System'));
    await tester.pump(const Duration(milliseconds: 200));
  });
}
