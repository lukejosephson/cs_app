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
        errorDetectionProvider.overrideWith(
          (ref) => pendingLoad.future,
        ),
      ]),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error state when challenge load fails', (tester) async {
    await tester.pumpWidget(
      _buildTestApp([
        errorDetectionProvider.overrideWith(
          (ref) => Future<List<ErrorDetectionChallenge>>.error(
            Exception('boom'),
          ),
        ),
      ]),
    );
    await tester.pump();

    expect(
      find.text('We could not load error detection challenges.'),
      findsOneWidget,
    );
    expect(find.text('Please try again in a moment.'), findsOneWidget);
  });

  testWidgets('renders interactive flow with submit and next', (tester) async {
    const challengeA = ErrorDetectionChallenge(
      id: 1,
      type: 'error_detection',
      snippet: 'var x = 0;\nif (x = 1) {\n  print(x);\n}',
      errorLine: 1,
      target: 'x',
      difficulty: 1,
      isArchived: false,
      tags: ['condition'],
    );
    const challengeB = ErrorDetectionChallenge(
      id: 2,
      type: 'error_detection',
      snippet: 'for (var i = 0; i < 3; i++) {\n  sum =+ i;\n}',
      errorLine: 1,
      target: 'sum',
      difficulty: 2,
      isArchived: false,
      tags: ['operator'],
    );

    await tester.pumpWidget(
      _buildTestApp([
        errorDetectionProvider.overrideWith(
          (ref) => Future.value(const [challengeA, challengeB]),
        ),
      ]),
    );
    await tester.pump();

    expect(find.text('Find the bug'), findsOneWidget);
    expect(find.text('2 challenge(s) loaded.'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('error-line-0')));
    await tester.pump();
    await tester.tap(find.text('Submit'));
    await tester.pump();
    expect(find.text('Not quite. Green shows the correct line.'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pump();
    expect(find.byKey(const ValueKey('selectable-code-block-2')), findsOneWidget);
    expect(find.text('Tap a line, then submit your choice.'), findsOneWidget);
  });
}
