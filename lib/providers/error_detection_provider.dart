import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/error_detection_challenge.dart';
import 'loop_provider.dart';

final errorDetectionProvider = FutureProvider<List<ErrorDetectionChallenge>>((
  ref,
) {
  return ref.watch(databaseServiceProvider).fetchErrorDetectionPuzzles();
});
