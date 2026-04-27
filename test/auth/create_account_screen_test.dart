import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs_app/providers/auth_provider.dart';

import '../helpers/fake_auth_service.dart';
import '../helpers/test_app.dart';

void main() {
  testWidgets('create account button opens create account screen', (
    tester,
  ) async {
    await pumpSignedOutApp(tester);

    await tester.tap(
      find.widgetWithIcon(OutlinedButton, Icons.person_add_alt_1_rounded),
    );
    await tester.pumpAndSettle();

    expect(find.text('Create your account'), findsOneWidget);
    expect(find.text('Verify Password'), findsOneWidget);
  });

  testWidgets('create account shows message for invalid email', (tester) async {
    await pumpSignedOutApp(tester);

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
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey('create-account-submit-button')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid email address.'), findsOneWidget);
  });

  testWidgets('create account shows message for invalid password', (
    tester,
  ) async {
    await pumpSignedOutApp(tester);

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

    expect(find.text('Please enter a password.'), findsOneWidget);
  });

  testWidgets('create account shows message when verification is missing', (
    tester,
  ) async {
    await pumpSignedOutApp(tester);

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

  testWidgets(
    'sign in screen shows success message after create account returns',
    (tester) async {
      await pumpSignedOutApp(tester);

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
    },
  );

  testWidgets('create account shows firebase failure and stays on screen', (
    tester,
  ) async {
    final fakeAuthService = FakeAuthService(
      createAccountError: FirebaseAuthException(code: 'email-already-in-use'),
    );

    await pumpSignedOutApp(
      tester,
      overrides: [authServiceProvider.overrideWithValue(fakeAuthService)],
    );

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
      'Password1',
    );
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey('create-account-submit-button')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Create your account'), findsOneWidget);
    expect(fakeAuthService.createAccountCallCount, 1);
    expect(fakeAuthService.signOutCalled, isFalse);
  });
}
