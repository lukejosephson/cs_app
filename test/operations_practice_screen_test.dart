import 'dart:async';

import 'package:cs_app/models/operations_practice_challenge.dart';
import 'package:cs_app/providers/operations_practice_provider.dart';
import 'package:cs_app/screens/operations_practice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildTestApp(List<Override> overrides) {
  return ProviderScope(
    overrides: overrides,
    child: const MaterialApp(home: OperationsPracticeScreen()),
  );
}

void main() {
  testWidgets('shows loading indicator while operations puzzles are loading', (
    tester,
  ) async {
    final completer = Completer<List<OperationsPracticeChallenge>>();
    await tester.pumpWidget(
      _buildTestApp([
        operationsPracticeProvider.overrideWith((ref) => completer.future),
      ]),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error state when operations provider fails', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp([
        operationsPracticeProvider.overrideWith(
          (ref) => Future<List<OperationsPracticeChallenge>>.error(
            Exception('boom'),
          ),
        ),
      ]),
    );
    await tester.pump();

    expect(
      find.text('Unable to load puzzles. Please check your connection.'),
      findsOneWidget,
    );
  });

  testWidgets('renders puzzle and checks submitted answer', (tester) async {
    const challenge = OperationsPracticeChallenge(
      id: 11,
      type: 'operations_practice',
      snippet: 'x = 3 + 4 * 2',
      errorLine: 0,
      target: 'What is x?',
      answer: '11',
      difficulty: 1,
      isArchived: false,
      tags: ['order-of-operations'],
    );

    await tester.pumpWidget(
      _buildTestApp([
        operationsPracticeProvider.overrideWith(
          (ref) => Future.value(const [challenge]),
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Operations practice'), findsOneWidget);
    expect(find.text('Target: What is x?'), findsOneWidget);
    expect(find.text('Check Answer'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('operations-answer-input')),
      '11',
    );
    await tester.tap(
      find.byKey(const ValueKey('operations-check-answer-button')),
    );
    await tester.pump();

    expect(find.text('Success! Correct answer.'), findsOneWidget);
  });
}
