import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/practice_type.dart';

final practiceOptionsProvider = Provider<List<PracticeType>>((ref) {
  return const [
    PracticeType(
      id: PracticeTypeId.binary,
      title: 'Binary Practice',
      description:
          'Convert values between decimal and binary using tile-based drills.',
    ),
    PracticeType(
      id: PracticeTypeId.loopScout,
      title: 'Loop Tracing',
      description:
          'Trace loop-based code snippets and predict final variable values.',
    ),
    PracticeType(
      id: PracticeTypeId.errorDetection,
      title: 'Error Detection',
      description:
          'Inspect code snippets and identify the exact line causing a bug.',
    ),
    PracticeType(
      id: PracticeTypeId.operationsPractice,
      title: 'Math Operations Practice',
      description: 'Master modulo, division, and precedence.',
    ),
  ];
});
