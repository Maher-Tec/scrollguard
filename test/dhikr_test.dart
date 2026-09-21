import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:scrollguard/features/intervention/screens/dhikr_exercise.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('tasbih counts each phrase separately and reset keeps today total', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DhikrExercise(),
        ),
      ),
    );

    // Initial pump and async load of SharedPreferences
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Dhikr'), findsOneWidget);
    expect(find.text('Another Dhikr'), findsOneWidget);
    expect(find.text('This Dhikr today'), findsOneWidget);
    expect(find.text('All today'), findsOneWidget);
    expect(find.text('0 / 33'), findsOneWidget);

    // Tap counter button
    await tester.tap(find.byKey(const ValueKey('dhikr_counter_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('1 / 33'), findsOneWidget);

    await tester.tap(find.byTooltip('Reset current count'));
    await tester.pump();
    expect(find.text('0 / 33'), findsOneWidget);
    expect(find.text('1'), findsWidgets);

    // Tap "Another Dhikr" button to cycle phrase
    await tester.tap(find.text('Another Dhikr'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('0 / 33'), findsOneWidget);
  });
}
