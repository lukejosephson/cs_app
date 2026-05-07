import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/practice_state.dart';
import '../models/puzzle.dart';
import '../models/user_progress.dart';
import 'auth_provider.dart';
import 'loop_provider.dart';
import 'puzzle_queue_provider.dart';
import 'user_progress_provider.dart';

abstract class BasePracticeController<TState extends PracticeState>
    extends Notifier<TState> {
  Future<void> updateProgress({
    required int puzzleId,
    required bool isCorrect,
  }) async {
    final uid = ref.read(userIdProvider);
    if (uid == null) return;

    final progress = await ref.read(userProgressProvider.future);
    final completed = List<int>.from(progress.completedPuzzles);
    final failed = List<int>.from(progress.failedPuzzles);

    if (isCorrect) {
      if (!completed.contains(puzzleId)) completed.add(puzzleId);
      failed.remove(puzzleId);
    } else {
      if (!failed.contains(puzzleId) && !completed.contains(puzzleId)) {
        failed.add(puzzleId);
      }
    }

    final updatedProgress = UserProgress(
      userId: uid,
      completedPuzzles: completed,
      failedPuzzles: failed,
    );

    await ref.read(databaseServiceProvider).updateUserProgress(updatedProgress);
    ref.invalidate(userProgressProvider);
  }

  int getNextPuzzleIndex<TPuzzle extends Puzzle>(List<TPuzzle> puzzles) {
    if (puzzles.isEmpty) return 0;

    final progress = ref.read(userProgressProvider).valueOrNull;
    if (progress == null) {
      return (state.currentPuzzleIndex + 1) % puzzles.length;
    }

    final nextPuzzle =
        ref.read(puzzleQueueServiceProvider).getNextPuzzle(puzzles, progress);

    return nextPuzzle != null ? puzzles.indexOf(nextPuzzle) : 0;
  }
}
