import 'dart:async';

import 'package:cs_app/models/error_detection_challenge.dart';
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
  testWidgets('shows loading indicator while challenges are loading', (
    tester,
  ) async {
    final pendingLoad = Completer<List<ErrorDetectionChallenge>>();
    await tester.pumpWidget(
      _buildTestApp([
        errorDetectionPuzzlesProvider.overrideWith((ref) => pendingLoad.future),
      ]),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error state when challenge load fails', (tester) async {
    await tester.pumpWidget(
      _buildTestApp([
        errorDetectionPuzzlesProvider.overrideWith(
          (ref) =>
              Future<List<ErrorDetectionChallenge>>.error(Exception('boom')),
        ),
      ]),
    );
    await tester.pump();

    expect(
      find.text('Unable to load puzzles. Please check your connection.'),
      findsOneWidget,
    );
  });

  testWidgets('renders interactive flow with submit and next', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const challengeA = ErrorDetectionChallenge(
      id: 1,
      type: 'error_detection',
      snippet: 'var x = 0;\nif (x = 1) {\n  print(x);\n}',
      errorLine: 1,
      target: 'Assignment in conditional',
      answer:
          "Use '==' for comparison; '=' performs assignment in the condition.",
      difficulty: 1,
      isArchived: false,
      tags: ['condition'],
    );
    const challengeB = ErrorDetectionChallenge(
      id: 2,
      type: 'error_detection',
      snippet: 'for (var i = 0; i < 3; i++) {\n  sum =+ i;\n}',
      errorLine: 1,
      target: 'Wrong operator',
      answer: "Use '+=' to accumulate values.",
      difficulty: 2,
      isArchived: false,
      tags: ['operator'],
    );

    await tester.pumpWidget(
      _buildTestApp([
        errorDetectionPuzzlesProvider.overrideWith(
          (ref) => Future.value(const [challengeA, challengeB]),
        ),
      ]),
    );
    await tester.pump();

    expect(find.text('Find the bug'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('error-line-number-field')),
      findsOneWidget,
    );
    expect(find.text('Submit'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('error-line-number-field')),
      '1',
    );
    await tester.pump();
    await tester.tap(find.text('Submit'));
    await tester.pump();
    expect(find.text('Not quite. The error is on line 2.'), findsOneWidget);
    expect(find.text('Assignment in conditional'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pump();
    expect(
      find.byKey(const ValueKey('selectable-code-block-2')),
      findsOneWidget,
    );
    expect(
      find.text('Enter the line number with the error, then submit.'),
      findsOneWidget,
    );
  });
}
