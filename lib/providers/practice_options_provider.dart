import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/practice_type.dart';

final practiceOptionsProvider = Provider<List<PracticeType>>((ref) {
  return const [
    PracticeType(
      title: 'Binary Practice',
      description:
          'Convert values between decimal and binary using tile-based drills.',
    ),
  ];
});
