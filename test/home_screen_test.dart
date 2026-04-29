import 'package:cs_app/screens/loop_scout_screen.dart';
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
    expect(find.text('Loop Scout'), findsOneWidget);
  });

  testWidgets('opens loop scout screen from home practice options', (
    tester,
  ) async {
    await pumpSignedInApp(tester);

    await tester.tap(find.text('Loop Scout'));
    await tester.pumpAndSettle();

    expect(find.text('Loop Scout'), findsOneWidget);
    expect(find.byType(LoopScoutScreen), findsOneWidget);
  });
}
