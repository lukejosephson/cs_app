import 'package:cs_app/models/loop_challenge.dart';
import 'package:cs_app/providers/loop_provider.dart';
import 'package:cs_app/screens/loop_scout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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
        puzzleProvider.overrideWith((ref) => const Stream<List<LoopChallenge>>.empty()),
      ]),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error state when puzzle stream fails', (tester) async {
    await tester.pumpWidget(
      _buildTestApp([
        puzzleProvider.overrideWith(
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

  testWidgets('shows placeholder column when puzzle data is available', (
    tester,
  ) async {
    const challenge = LoopChallenge(
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

    await tester.pumpWidget(
      _buildTestApp([
        puzzleProvider.overrideWith(
          (ref) => Stream<List<LoopChallenge>>.value(const [challenge]),
        ),
      ]),
    );
    await tester.pump();

    expect(find.text('Loop tracing'), findsOneWidget);
    expect(find.text('1 challenge(s) loaded.'), findsOneWidget);
    expect(find.byType(Placeholder), findsOneWidget);
  });
}
