import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/operations_practice_challenge.dart';
import 'loop_provider.dart';

final operationsPracticeProvider =
    FutureProvider<List<OperationsPracticeChallenge>>((ref) {
      return ref.watch(databaseServiceProvider).fetchOperationsPuzzles();
    });
