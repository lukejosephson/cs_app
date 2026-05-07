// import 'package:cs_app/providers/operations_practice_controller.dart';
// import 'package:cs_app/widgets/operations_input_panel.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   testWidgets('shows target prompt and input controls', (tester) async {
//     await tester.pumpWidget(
//       const ProviderScope(
//         child: MaterialApp(
//           home: Scaffold(
//             body: OperationsInputPanel(
//               puzzleId: 1,
//               targetPrompt: 'What is x?',
//               correctAnswer: '11',
//             ),
//           ),
//         ),
//       ),
//     );

//     expect(find.text('Target: What is x?'), findsOneWidget);
//     expect(
//       find.byKey(const ValueKey('operations-answer-input')),
//       findsOneWidget,
//     );
//     expect(
//       find.byKey(const ValueKey('operations-check-answer-button')),
//       findsOneWidget,
//     );
//   });
// }
