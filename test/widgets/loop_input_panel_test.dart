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
}
