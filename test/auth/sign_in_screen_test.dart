import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('shows sign in screen when user is unauthenticated', (tester) async {
    await pumpSignedOutApp(tester);

    expect(find.text('Sign in to CS Practice'), findsOneWidget);
    expect(find.text('Sign in with Email'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue Anonymously'), findsNothing);
  });
}
