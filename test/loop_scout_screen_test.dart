import 'package:cs_app/models/loop_challenge.dart';
import 'package:cs_app/providers/loop_provider.dart';
import 'package:cs_app/providers/loop_tracing_provider.dart';
import 'package:cs_app/screens/loop_scout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_random.dart';

Widget _buildTestApp(List<Override> overrides) {
  return ProviderScope(
    overrides: overrides,
    child: const MaterialApp(home: LoopScoutScreen()),
  );
}

void main() {
  testWidgets('shows loading indicator while puzzles are loading', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp([
        loopPuzzlesProvider.overrideWith(
          (ref) => const Stream<List<LoopChallenge>>.empty(),
        ),
      ]),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error state when puzzle stream fails', (tester) async {
    await tester.pumpWidget(
      _buildTestApp([
        loopPuzzlesProvider.overrideWith(
          (ref) => Stream<List<LoopChallenge>>.error(Exception('boom')),
        ),
      ]),
    );
    await tester.pump();

    expect(
      find.text('We could not load loop challenges right now.'),
      findsOneWidget,
    );
    expect(find.text('Please try again in a moment.'), findsOneWidget);
  });

  testWidgets('shows empty-data state when no puzzles are returned', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp([
        loopPuzzlesProvider.overrideWith(
          (ref) => Stream<List<LoopChallenge>>.value(const []),
        ),
      ]),
    );
    await tester.pump();

    expect(
      find.text('No loop challenges available right now.'),
      findsOneWidget,
    );
    expect(find.text('Check Answer'), findsNothing);
  });

  testWidgets('shows interaction widgets when puzzle data is available', (
    tester,
  ) async {
    const challengeA = LoopChallenge(
      id: 1,
      type: 'loop_scout',
      snippet: 'for (var i = 0; i < 3; i++) { total += i; }',
      target: 'total',
      answer: '3',
      errorLine: 0,
      difficulty: 1,
      isArchived: false,
      tags: ['loop'],
    );
    const challengeB = LoopChallenge(
      id: 2,
      type: 'loop_scout',
      snippet: 'for (var i = 0; i < 2; i++) { count += i; }',
      target: 'count',
      answer: '1',
      errorLine: 0,
      difficulty: 1,
      isArchived: false,
      tags: ['loop'],
    );

    await tester.pumpWidget(
      _buildTestApp([
        loopPuzzlesProvider.overrideWith(
          (ref) =>
              Stream<List<LoopChallenge>>.value(const [challengeA, challengeB]),
        ),
        loopRandomProvider.overrideWithValue(FakeRandom([0])),
      ]),
    );
    await tester.pump();

    expect(find.text('Loop tracing'), findsOneWidget);
    expect(find.text('2 challenge(s) loaded.'), findsOneWidget);
    expect(find.text('Retry pool: 0'), findsOneWidget);
    expect(find.text('Difficulty: 1'), findsOneWidget);
    expect(find.text('Tags: loop'), findsOneWidget);
    expect(find.byKey(const ValueKey('loop-answer-input')), findsOneWidget);
    expect(find.text('Target variable: total'), findsOneWidget);
    expect(find.text('Check Answer'), findsOneWidget);
    expect(find.text('Next Challenge'), findsOneWidget);
    expect(find.text('Random'), findsOneWidget);

    await tester.tap(find.text('Next Challenge'));
    await tester.pump();
    expect(find.text('Target variable: count'), findsOneWidget);

    await tester.tap(find.text('Random'));
    await tester.pump();
    expect(find.text('Target variable: total'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('loop-answer-input')),
      'nope',
    );
    await tester.tap(find.text('Check Answer'));
    await tester.pump();
    expect(find.text('Retry pool: 1'), findsOneWidget);
  });

  testWidgets('resets input intentionally when moving to next challenge', (
    tester,
  ) async {
    const challengeA = LoopChallenge(
      id: 1,
      type: 'loop_scout',
      snippet: 'for (var i = 0; i < 3; i++) { total += i; }',
      target: 'total',
      answer: '3',
      errorLine: 0,
      difficulty: 1,
      isArchived: false,
      tags: ['loop'],
    );
    const challengeB = LoopChallenge(
      id: 2,
      type: 'loop_scout',
      snippet: 'for (var i = 0; i < 2; i++) { count += i; }',
      target: 'count',
      answer: '1',
      errorLine: 0,
      difficulty: 1,
      isArchived: false,
      tags: ['loop'],
    );

    await tester.pumpWidget(
      _buildTestApp([
        loopPuzzlesProvider.overrideWith(
          (ref) =>
              Stream<List<LoopChallenge>>.value(const [challengeA, challengeB]),
        ),
      ]),
    );
    await tester.pump();

    await tester.enterText(
      find.byKey(const ValueKey('loop-answer-input')),
      '3',
    );
    await tester.tap(find.text('Check Answer'));
    await tester.pump();
    expect(find.text('Success! Correct answer.'), findsOneWidget);

    await tester.tap(find.text('Next Challenge'));
    await tester.pump();

    final answerField = tester.widget<TextField>(
      find.byKey(const ValueKey('loop-answer-input')),
    );
    expect(answerField.controller?.text ?? '', isEmpty);
    expect(find.text('Success! Correct answer.'), findsNothing);
  });

  testWidgets('shows fallback when all loaded puzzles are malformed', (
    tester,
  ) async {
    const malformedChallenge = LoopChallenge(
      id: 10,
      type: 'loop_scout',
      snippet: '',
      target: 'total',
      answer: '',
      errorLine: 0,
      difficulty: 1,
      isArchived: false,
      tags: ['loop'],
    );

    await tester.pumpWidget(
      _buildTestApp([
        loopPuzzlesProvider.overrideWith(
          (ref) =>
              Stream<List<LoopChallenge>>.value(const [malformedChallenge]),
        ),
      ]),
    );
    await tester.pump();

    expect(
      find.text('No valid loop challenges available right now.'),
      findsOneWidget,
    );
    expect(find.text('Check Answer'), findsNothing);
  });
}
