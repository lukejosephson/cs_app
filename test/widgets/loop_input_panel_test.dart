import 'package:cs_app/widgets/loop_input_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows target prompt and input controls', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: LoopInputPanel(
              puzzleId: 1,
              targetVariable: 'total',
              correctAnswer: '6',
            ),
          ),
        ),
      ),
    );

    expect(find.text('Target variable: total'), findsOneWidget);
    expect(find.byKey(const ValueKey('loop-answer-input')), findsOneWidget);
    expect(find.byKey(const ValueKey('loop-check-answer-button')), findsOneWidget);
  });
}
