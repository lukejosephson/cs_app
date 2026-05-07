// import 'package:cs_app/providers/loop_tracing_provider.dart';
// import 'package:cs_app/widgets/loop_input_panel.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   Widget buildApp() {
//     return const ProviderScope(
//       child: MaterialApp(
//         home: Scaffold(
//           body: LoopInputPanel(
//             puzzleId: 1,
//             targetVariable: 'total',
//             correctAnswer: '6',
//           ),
//         ),
//       ),
//     );
//   }

//   testWidgets('shows success message when answer is correct', (tester) async {
//     await tester.pumpWidget(buildApp());

//     await tester.enterText(
//       find.byKey(const ValueKey('loop-answer-input')),
//       '6',
//     );
//     await tester.tap(find.byKey(const ValueKey('loop-check-answer-button')));
//     await tester.pump();

//     expect(find.text('Success! Correct answer.'), findsOneWidget);
//   });
// }
