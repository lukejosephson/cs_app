import 'package:cs_app/main.dart';
import 'package:cs_app/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpSignedInApp(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authStateProvider.overrideWith((ref) => Stream<bool>.value(true)),
      ],
      child: const CsPracticeApp(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> pumpSignedOutApp(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authStateProvider.overrideWith((ref) => Stream<bool>.value(false)),
      ],
      child: const CsPracticeApp(),
    ),
  );
  await tester.pumpAndSettle();
}
