import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_progress.dart';
import 'auth_provider.dart';
import 'loop_provider.dart';

final userProgressProvider = FutureProvider<UserProgress>((ref) async {
  final uid = ref.watch(userIdProvider);
  if (uid == null) return UserProgress.empty('');
  
  final databaseService = ref.read(databaseServiceProvider);
  return databaseService.getUserProgress(uid);
});
