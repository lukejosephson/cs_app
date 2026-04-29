import 'package:cs_app/providers/loop_tracing_provider.dart';
import 'package:cs_app/widgets/loop_input_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp() {
    return const ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: LoopInputPanel(
            puzzleId: 1,
            targetVariable: 'total',
            correctAnswer: '6',
          ),
        ),
      ),
    );
  }

  testWidgets('shows success message when answer is correct', (tester) async {
    await tester.pumpWidget(buildApp());

    await tester.enterText(
      find.byKey(const ValueKey('loop-answer-input')),
      '6',
    );
    await tester.tap(find.byKey(const ValueKey('loop-check-answer-button')));
    await tester.pump();

    expect(find.text('Success! Correct answer.'), findsOneWidget);
  });

  testWidgets('shows validation message when answer is empty', (tester) async {
    await tester.pumpWidget(buildApp());

    await tester.tap(find.byKey(const ValueKey('loop-check-answer-button')));
    await tester.pump();

    expect(
      find.text('Please enter an answer before checking.'),
      findsOneWidget,
    );
    expect(find.text('Success! Correct answer.'), findsNothing);
  });

  testWidgets('shows correct answer when answer is wrong', (tester) async {
    await tester.pumpWidget(buildApp());

    await tester.enterText(
      find.byKey(const ValueKey('loop-answer-input')),
      '5',
    );
    await tester.tap(find.byKey(const ValueKey('loop-check-answer-button')));
    await tester.pump();

    expect(find.text('Not quite. Correct answer: 6'), findsOneWidget);
  });

  testWidgets('treats case and extra spaces as equivalent answers', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: LoopInputPanel(
              puzzleId: 1,
              targetVariable: 'phrase',
              correctAnswer: 'hello world',
            ),
          ),
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const ValueKey('loop-answer-input')),
      '  Hello   World  ',
    );
    await tester.tap(find.byKey(const ValueKey('loop-check-answer-button')));
    await tester.pump();

    expect(find.text('Success! Correct answer.'), findsOneWidget);
  });

  testWidgets('uses loop scout controller provider alias', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final loopScoutController = container.read(
      loopScoutControllerProvider.notifier,
    );
    final loopTracingController = container.read(
      loopTracingControllerProvider.notifier,
    );

    expect(identical(loopScoutController, loopTracingController), isTrue);
  });

  testWidgets(
    'syncs TextField when controller input is updated programmatically',
    (tester) async {
      await tester.pumpWidget(buildApp());

      final context = tester.element(find.byType(LoopInputPanel));
      final container = ProviderScope.containerOf(context, listen: false);

      container.read(loopScoutControllerProvider.notifier).updateInput('12');
      await tester.pump();

      final answerField = tester.widget<TextField>(
        find.byKey(const ValueKey('loop-answer-input')),
      );
      expect(answerField.controller?.text, '12');
    },
  );

  testWidgets('clears input and feedback when puzzle id changes', (
    tester,
  ) async {
    var puzzleId = 1;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: ListView(
                  children: [
                    LoopInputPanel(
                      puzzleId: puzzleId,
                      targetVariable: puzzleId == 1 ? 'total' : 'count',
                      correctAnswer: puzzleId == 1 ? '6' : '2',
                    ),
                    TextButton(
                      onPressed: () => setState(() => puzzleId = 2),
                      child: const Text('Switch Puzzle'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const ValueKey('loop-answer-input')),
      '6',
    );
    await tester.tap(find.byKey(const ValueKey('loop-check-answer-button')));
    await tester.pump();
    expect(find.text('Success! Correct answer.'), findsOneWidget);

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Switch Puzzle'));
    await tester.pumpAndSettle();

    final answerField = tester.widget<TextField>(
      find.byKey(const ValueKey('loop-answer-input')),
    );
    expect(answerField.controller?.text ?? '', isEmpty);
    expect(find.text('Success! Correct answer.'), findsNothing);
  });
}
