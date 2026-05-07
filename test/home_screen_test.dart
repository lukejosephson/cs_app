import 'package:cs_app/screens/loop_scout_screen.dart';
import 'package:cs_app/screens/error_detection_screen.dart';
import 'package:cs_app/screens/operations_practice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

void main() {
  testWidgets('shows welcome content and available practice options', (
    tester,
  ) async {
    await pumpSignedInApp(tester);

    expect(find.text('Welcome to CS Practice'), findsOneWidget);
    expect(find.text('Practice Types'), findsOneWidget);
    expect(find.text('Binary Practice'), findsOneWidget);
    expect(find.text('Loop Tracing'), findsOneWidget);
    expect(find.text('Error Detection'), findsOneWidget);
    expect(find.text('Math Operations Practice'), findsOneWidget);
    expect(find.byIcon(Icons.brightness_6), findsOneWidget);
  });

  testWidgets('opens loop scout screen from home practice options', (
    tester,
  ) async {
    await pumpSignedInApp(tester);

    await tester.tap(find.text('Loop Tracing'));
    await tester.pumpAndSettle();

    expect(find.text('Loop Tracing'), findsOneWidget);
    expect(find.byType(LoopScoutScreen), findsOneWidget);
  });

  testWidgets('opens error detection screen from home practice options', (
    tester,
  ) async {
    await pumpSignedInApp(tester);

    await tester.tap(find.text('Error Detection'));
    await tester.pumpAndSettle();

    expect(find.text('Error Detection'), findsOneWidget);
    expect(find.byType(ErrorDetectionScreen), findsOneWidget);
  });

  testWidgets('opens operations practice screen from home list tile', (
    tester,
  ) async {
    await pumpSignedInApp(tester);

    final operationsTile = find.byKey(
      const ValueKey('home-operations-practice-tile'),
    );
    final tileWidget = tester.widget<ListTile>(operationsTile);
    tileWidget.onTap?.call();
    await tester.pumpAndSettle();

    expect(find.text('Operations Practice'), findsOneWidget);
    expect(find.byType(OperationsPracticeScreen), findsOneWidget);
  });
}
