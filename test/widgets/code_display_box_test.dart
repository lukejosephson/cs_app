import 'package:cs_app/widgets/code_display_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  testWidgets('renders multiline snippet with monospace font styling', (
    tester,
  ) async {
    const snippet = 'for (var i = 0; i < 3; i++) {\n  total += i;\n}';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CodeDisplayBox(snippet: snippet),
        ),
      ),
    );

    expect(find.text(snippet), findsOneWidget);

    final selectableText = tester.widget<SelectableText>(
      find.byType(SelectableText),
    );
    final expectedFontFamily = GoogleFonts.firaCode().fontFamily;
    expect(selectableText.style?.fontFamily, expectedFontFamily);
  });

  testWidgets('uses dark container and subtle border', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CodeDisplayBox(snippet: 'print("hello")'),
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration! as BoxDecoration;

    expect(decoration.color, const Color(0xFF0F162A));
    expect(decoration.border, isNotNull);
  });
}
