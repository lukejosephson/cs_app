import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/loop_challenge.dart';
import '../services/database_service.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return FirestoreDatabaseService();
});

final loopPuzzlesProvider = StreamProvider<List<LoopChallenge>>((ref) {
  return ref.watch(databaseServiceProvider).getLoopPuzzles();
});
