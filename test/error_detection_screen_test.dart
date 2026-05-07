import 'dart:async';

import 'package:cs_app/models/error_detection_challenge.dart';
import 'package:cs_app/providers/auth_provider.dart';
import 'package:cs_app/providers/error_detection_provider.dart';
import 'package:cs_app/screens/error_detection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildTestApp(List<Override> overrides) {
  return ProviderScope(
    overrides: overrides,
    child: const MaterialApp(home: ErrorDetectionScreen()),
  );
}

void main() {
  testWidgets('shows loading indicator while error puzzles are loading', (
    tester,
  ) async {
    final completer = Completer<List<ErrorDetectionChallenge>>();
    await tester.pumpWidget(
      _buildTestApp([
        errorDetectionPuzzlesProvider.overrideWith((ref) => completer.future),
      ]),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('submits selected line number and shows explanation', (
    tester,
  ) async {
    const challenge = ErrorDetectionChallenge(
      id: 7,
      type: 'error_detection',
      snippet: 'int value = 10;\nprint(value + 1);\nprint(total);',
      errorLine: 2,
      target: 'total is undefined in this scope.',
      answer: 'Use value or define total before printing.',
      difficulty: 1,
      isArchived: false,
      tags: ['variables'],
    );

    await tester.pumpWidget(
      _buildTestApp([
        errorDetectionPuzzlesProvider.overrideWith(
          (ref) => Future.value(const [challenge]),
        ),
        userIdProvider.overrideWith((ref) => null),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Find the bug'), findsOneWidget);
    expect(find.byKey(const ValueKey('error-line-number-field')), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('error-line-number-field')),
      '3',
    );
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Correct! The error is on line 3.'), findsOneWidget);
    expect(find.text('Error explanation'), findsOneWidget);
    expect(find.text('total is undefined in this scope.'), findsOneWidget);
  });
}
