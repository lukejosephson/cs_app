import 'package:cs_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows welcome content and binary practice option', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CsPracticeApp()));

    expect(find.text('Welcome to CS Practice'), findsOneWidget);
    expect(find.text('Practice Types'), findsOneWidget);
    expect(find.text('Binary Practice'), findsOneWidget);
  });
}
