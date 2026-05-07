import 'package:cs_app/widgets/operations_input_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildTestWidget({
  required int puzzleId,
  required String targetPrompt,
  required String correctAnswer,
}) {
  return ProviderScope(
    child: MaterialApp(
      home: Scaffold(
        body: OperationsInputPanel(
          key: ValueKey('operations-input-panel-$puzzleId'),
          puzzleId: puzzleId,
          targetPrompt: targetPrompt,
          correctAnswer: correctAnswer,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('shows target prompt and input controls', (tester) async {
    await tester.pumpWidget(
      _buildTestWidget(
        puzzleId: 1,
        targetPrompt: 'What is x?',
        correctAnswer: '11',
      ),
    );

    expect(find.text('Target: What is x?'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('operations-answer-input')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('operations-check-answer-button')),
      findsOneWidget,
    );
  });

  testWidgets('shows success message when answer is correct', (tester) async {
    await tester.pumpWidget(
      _buildTestWidget(
        puzzleId: 1,
        targetPrompt: 'What is x?',
        correctAnswer: '11',
      ),
    );

    await tester.enterText(
      find.byKey(const ValueKey('operations-answer-input')),
      ' 11 ',
    );
    await tester.tap(
      find.byKey(const ValueKey('operations-check-answer-button')),
    );
    await tester.pump();

    expect(find.text('Success! Correct answer.'), findsOneWidget);
  });

  testWidgets('shows correct answer when submission is wrong', (tester) async {
    await tester.pumpWidget(
      _buildTestWidget(
        puzzleId: 1,
        targetPrompt: 'What is x?',
        correctAnswer: '11',
      ),
    );

    await tester.enterText(
      find.byKey(const ValueKey('operations-answer-input')),
      '12',
    );
    await tester.tap(
      find.byKey(const ValueKey('operations-check-answer-button')),
    );
    await tester.pump();

    expect(find.text('Not quite. Correct answer: 11'), findsOneWidget);
  });
}
