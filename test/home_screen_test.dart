import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

void main() {
  testWidgets('shows welcome content and available practice options', (
    tester,
  ) async {
    await pumpSignedInApp(tester);

    expect(find.text('Welcome to CS Practice'), findsOneWidget);
    expect(find.text('Practice Types'), findsOneWidget);
    expect(find.text('Binary Practice'), findsOneWidget);
    expect(find.text('Loop Tracing'), findsOneWidget);
    expect(find.text('Error Detection'), findsOneWidget);
    expect(find.text('Math Operations Practice'), findsOneWidget);
  });
}
