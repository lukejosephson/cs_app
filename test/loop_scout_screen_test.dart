import 'dart:async';

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
    final controller = StreamController<List<LoopChallenge>>();
    addTearDown(controller.close);

    await tester.pumpWidget(
      _buildTestApp([
        loopPuzzlesProvider.overrideWith((ref) => controller.stream),
      ]),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders loop puzzle content when data is available', (
    tester,
  ) async {
    const puzzle = LoopChallenge(
      id: 1,
      type: 'loop_scout',
      snippet: 'int total = 0;\nfor (int i = 0; i < 3; i++) {\n  total += i;\n}',
      target: 'total',
      answer: '3',
      errorLine: 0,
      difficulty: 1,
      isArchived: false,
      tags: ['for-loop'],
    );

    await tester.pumpWidget(
      _buildTestApp([
        loopPuzzlesProvider.overrideWith((ref) => Stream.value(const [puzzle])),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Loop tracing'), findsOneWidget);
    expect(find.text('Target variable: total'), findsOneWidget);
    expect(find.text('Next Challenge'), findsOneWidget);
  });
}
