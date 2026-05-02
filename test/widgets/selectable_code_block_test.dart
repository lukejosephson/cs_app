import 'package:cs_app/widgets/selectable_code_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _build({
  required int? selectedLineIndex,
  required bool hasSubmitted,
  required bool? isCorrect,
  required int correctLineIndex,
}) {
  return MaterialApp(
    theme: ThemeData.dark(useMaterial3: true),
    home: Scaffold(
      body: SelectableCodeBlock(
        snippet: 'line one\nline two\nline three',
        selectedLineIndex: selectedLineIndex,
        hasSubmitted: hasSubmitted,
        isCorrect: isCorrect,
        correctLineIndex: correctLineIndex,
        onLineSelected: (_) {},
      ),
    ),
  );
}

void main() {
  testWidgets('renders each snippet line as tappable row', (tester) async {
    await tester.pumpWidget(
      _build(
        selectedLineIndex: null,
        hasSubmitted: false,
        isCorrect: null,
        correctLineIndex: 1,
      ),
    );

    expect(find.byKey(const ValueKey('error-line-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('error-line-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('error-line-2')), findsOneWidget);
    expect(find.byType(InkWell), findsNWidgets(3));
  });

  testWidgets('submission highlights selected and correct lines', (tester) async {
    await tester.pumpWidget(
      _build(
        selectedLineIndex: 0,
        hasSubmitted: true,
        isCorrect: false,
        correctLineIndex: 1,
      ),
    );

    final selectedLine = tester.widget<Container>(
      find.descendant(
        of: find.byKey(const ValueKey('error-line-0')),
        matching: find.byType(Container),
      ).first,
    );
    final correctLine = tester.widget<Container>(
      find.descendant(
        of: find.byKey(const ValueKey('error-line-1')),
        matching: find.byType(Container),
      ).first,
    );

    final selectedDecoration = selectedLine.decoration! as BoxDecoration;
    final correctDecoration = correctLine.decoration! as BoxDecoration;

    expect(selectedDecoration.color, isNotNull);
    expect(correctDecoration.color, isNotNull);
    expect(selectedDecoration.color, isNot(equals(correctDecoration.color)));
  });
}
