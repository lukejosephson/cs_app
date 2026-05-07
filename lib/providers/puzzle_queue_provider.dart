import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/puzzle.dart';
import '../models/user_progress.dart';

/// Service class that implements the puzzle selection algorithm.
/// 
/// The algorithm prioritizes unattempted puzzles, then failed puzzles (retries),
/// and finally falls back to random puzzles if everything is mastered.
class PuzzleQueueService {
  PuzzleQueueService({Random? random}) : _random = random ?? Random();

  final Random _random;

  /// Selects the next puzzle based on user progress.
  /// 
  /// 1. Prioritizes puzzles NOT in [progress.completedPuzzles] and NOT in [progress.failedPuzzles].
  /// 2. If all attempted, prioritizes puzzles in [progress.failedPuzzles].
  /// 3. If everything is mastered, returns a random puzzle from [allPuzzles].
  T? getNextPuzzle<T extends Puzzle>(List<T> allPuzzles, UserProgress progress) {
    if (allPuzzles.isEmpty) return null;

    // Step 1: Filter unattemptedPuzzles
    final unattemptedPuzzles = allPuzzles.where((p) {
      final isCompleted = progress.completedPuzzles.contains(p.id);
      final isFailed = progress.failedPuzzles.contains(p.id);
      return !isCompleted && !isFailed;
    }).toList();

    // Step 2: Select random unattempted
    if (unattemptedPuzzles.isNotEmpty) {
      return unattemptedPuzzles[_random.nextInt(unattemptedPuzzles.length)];
    }

    // Step 3 & 4: Filter and select from retryPuzzles (failed)
    final retryPuzzles = allPuzzles.where((p) => 
      progress.failedPuzzles.contains(p.id)
    ).toList();

    if (retryPuzzles.isNotEmpty) {
      return retryPuzzles[_random.nextInt(retryPuzzles.length)];
    }

    // Step 5: Fallback to random if everything is completed
    return allPuzzles[_random.nextInt(allPuzzles.length)];
  }
}

/// Provider for the [PuzzleQueueService].
final puzzleQueueServiceProvider = Provider<PuzzleQueueService>((ref) {
  return PuzzleQueueService();
});
