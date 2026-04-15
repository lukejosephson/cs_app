import 'dart:math';

import 'package:cs_app/main.dart';
import 'package:cs_app/providers/auth_provider.dart';
import 'package:cs_app/providers/binary_practice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows welcome content and binary practice option', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream<bool>.value(true)),
        ],
        child: const CsPracticeApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome to CS Practice'), findsOneWidget);
    expect(find.text('Practice Types'), findsOneWidget);
    expect(find.text('Binary Practice'), findsOneWidget);
  });

  testWidgets('opens binary practice screen with seven flippable bits', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream<bool>.value(true)),
        ],
        child: const CsPracticeApp(),
      ),
    );
    await tester.pumpAndSettle();

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
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream<bool>.value(true)),
        ],
        child: const CsPracticeApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Binary Practice'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Your Value:'), findsOneWidget);
    expect(find.text('64'), findsOneWidget);

    await tester.tap(find.widgetWithText(SwitchListTile, 'Show current value'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Your Value:'), findsNothing);

    await tester.tap(find.widgetWithText(SwitchListTile, 'Show bit place values'));
    await tester.pumpAndSettle();
    expect(find.text('64'), findsNothing);
  });

  testWidgets('correct answer feedback includes number and binary equivalent', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream<bool>.value(true)),
          randomProvider.overrideWithValue(_FakeRandom([5, 9])),
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

    expect(find.textContaining('The binary equivalent of 5 is 0000101'), findsOneWidget);
  });

  testWidgets('shows sign in screen when user is unauthenticated', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream<bool>.value(false)),
        ],
        child: const CsPracticeApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sign in to CS Practice'), findsOneWidget);
    expect(find.text('Sign in with Email'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue Anonymously'), findsNothing);
  });

  testWidgets('create account button opens create account screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream<bool>.value(false)),
        ],
        child: const CsPracticeApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.widgetWithIcon(OutlinedButton, Icons.person_add_alt_1_rounded),
    );
    await tester.pumpAndSettle();

    expect(find.text('Create your account'), findsOneWidget);
    expect(find.text('Verify Password'), findsOneWidget);
  });

  testWidgets('create account shows message for invalid email', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream<bool>.value(false)),
        ],
        child: const CsPracticeApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.widgetWithIcon(OutlinedButton, Icons.person_add_alt_1_rounded),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('create-account-email-field')),
      'bad-email',
    );
    await tester.enterText(
      find.byKey(const ValueKey('create-account-password-field')),
      'Password1',
    );
    await tester.enterText(
      find.byKey(const ValueKey('create-account-confirm-password-field')),
      'Password1',
    );
    await tester.tap(
      find.byKey(const ValueKey('create-account-submit-button')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid email address.'), findsOneWidget);
  });

  testWidgets('create account shows message for invalid password', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream<bool>.value(false)),
        ],
        child: const CsPracticeApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.widgetWithIcon(OutlinedButton, Icons.person_add_alt_1_rounded),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('create-account-email-field')),
      'user@example.com',
    );
    await tester.enterText(
      find.byKey(const ValueKey('create-account-password-field')),
      '',
    );
    await tester.enterText(
      find.byKey(const ValueKey('create-account-confirm-password-field')),
      '',
    );
    await tester.tap(
      find.byKey(const ValueKey('create-account-submit-button')),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Please enter a password.'),
      findsOneWidget,
    );
  });

  testWidgets('create account shows message when verification is missing', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream<bool>.value(false)),
        ],
        child: const CsPracticeApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.widgetWithIcon(OutlinedButton, Icons.person_add_alt_1_rounded),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('create-account-email-field')),
      'user@example.com',
    );
    await tester.enterText(
      find.byKey(const ValueKey('create-account-password-field')),
      'Password1',
    );
    await tester.enterText(
      find.byKey(const ValueKey('create-account-confirm-password-field')),
      '',
    );
    await tester.tap(
      find.byKey(const ValueKey('create-account-submit-button')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Please verify your password.'), findsOneWidget);
  });

  testWidgets('sign in screen shows success message after create account returns', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream<bool>.value(false)),
        ],
        child: const CsPracticeApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.widgetWithIcon(OutlinedButton, Icons.person_add_alt_1_rounded),
    );
    await tester.pumpAndSettle();

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pop('Account created successfully. Please sign in.');
    await tester.pumpAndSettle();

    expect(
      find.text('Account created successfully. Please sign in.'),
      findsOneWidget,
    );
  });
}

class _FakeRandom implements Random {
  _FakeRandom(this._values);

  final List<int> _values;
  var _index = 0;

  @override
  int nextInt(int max) {
    final value = _values[_index % _values.length];
    _index++;
    return value % max;
  }

  @override
  bool nextBool() => nextInt(2) == 1;

  @override
  double nextDouble() => nextInt(1000000) / 1000000;
}
