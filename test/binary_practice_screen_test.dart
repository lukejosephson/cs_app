import 'package:cs_app/main.dart';
import 'package:cs_app/providers/auth_provider.dart';
import 'package:cs_app/providers/binary_practice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fake_random.dart';
import 'helpers/test_app.dart';

void main() {
  testWidgets('opens binary practice screen with seven flippable bits', (
    tester,
  ) async {
    await pumpSignedInApp(tester);

    await tester.tap(find.text('Binary Practice'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Target Number:'), findsOneWidget);
    expect(find.byKey(const ValueKey('bit-toggle-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('bit-toggle-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('bit-toggle-2')), findsOneWidget);
    expect(find.byKey(const ValueKey('bit-toggle-3')), findsOneWidget);
    expect(find.byKey(const ValueKey('bit-toggle-4')), findsOneWidget);
    expect(find.byKey(const ValueKey('bit-toggle-5')), findsOneWidget);
    expect(find.byKey(const ValueKey('bit-toggle-6')), findsOneWidget);
    expect(find.text('Check Answer'), findsOneWidget);
  });

  testWidgets('binary practice visibility toggles work', (tester) async {
    await pumpSignedInApp(tester);

    await tester.tap(find.text('Binary Practice'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Your Value:'), findsOneWidget);
    expect(find.text('64'), findsOneWidget);

    await tester.tap(find.widgetWithText(SwitchListTile, 'Show current value'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Your Value:'), findsNothing);

    await tester.tap(
      find.widgetWithText(SwitchListTile, 'Show bit place values'),
    );
    await tester.pumpAndSettle();
    expect(find.text('64'), findsNothing);
  });

  testWidgets('correct answer feedback includes number and binary equivalent', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream<bool>.value(true)),
          randomProvider.overrideWithValue(FakeRandom([5, 9])),
        ],
        child: const CsPracticeApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Binary Practice'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('bit-toggle-4'))); // 4
    await tester.tap(find.byKey(const ValueKey('bit-toggle-6'))); // 1
    await tester.pumpAndSettle();

    await tester.tap(find.text('Check Answer'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('The binary equivalent of 5 is 0000101'),
      findsOneWidget,
    );
  });

  testWidgets('binary visibility settings persist across app restarts', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();

    Future<void> pumpApp() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => Stream<bool>.value(true)),
            randomProvider.overrideWithValue(FakeRandom([5])),
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ],
          child: const CsPracticeApp(),
        ),
      );
      await tester.pumpAndSettle();
    }

    await pumpApp();
    await tester.tap(find.text('Binary Practice'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(SwitchListTile, 'Show current value'));
    await tester.tap(
      find.widgetWithText(SwitchListTile, 'Show bit place values'),
    );
    await tester.pumpAndSettle();

    expect(sharedPreferences.getBool('binary.showCurrentValue'), isFalse);
    expect(sharedPreferences.getBool('binary.showBitPlaceValues'), isFalse);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();

    await pumpApp();
    await tester.tap(find.text('Binary Practice'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Your Value:'), findsNothing);
    expect(find.text('64'), findsNothing);
  });
}
