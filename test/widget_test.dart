import 'package:cs_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows welcome content and binary practice option', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CsPracticeApp()));

    expect(find.text('Welcome to CS Practice'), findsOneWidget);
    expect(find.text('Practice Types'), findsOneWidget);
    expect(find.text('Binary Practice'), findsOneWidget);
  });

  testWidgets('opens binary practice screen with six flippable bits', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CsPracticeApp()));

    await tester.tap(find.text('Binary Practice'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Target Number:'), findsOneWidget);
    expect(find.byKey(const ValueKey('bit-toggle-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('bit-toggle-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('bit-toggle-2')), findsOneWidget);
    expect(find.byKey(const ValueKey('bit-toggle-3')), findsOneWidget);
    expect(find.byKey(const ValueKey('bit-toggle-4')), findsOneWidget);
    expect(find.byKey(const ValueKey('bit-toggle-5')), findsOneWidget);
    expect(find.text('Check Answer'), findsOneWidget);
  });
}
