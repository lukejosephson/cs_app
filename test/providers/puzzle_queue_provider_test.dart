import 'package:cs_app/models/puzzle.dart';
import 'package:cs_app/models/user_progress.dart';
import 'package:cs_app/providers/puzzle_queue_provider.dart';
import 'package:flutter_test/flutter_test.dart';

class MockPuzzle implements Puzzle {
  const MockPuzzle(this.id);
  @override
  final int id;
}

void main() {
  group('PuzzleQueueService', () {
    final puzzles = [
      const MockPuzzle(1),
      const MockPuzzle(2),
      const MockPuzzle(3),
      const MockPuzzle(4),
    ];

    test('prioritizes unattempted puzzles', () {
      final service = PuzzleQueueService();
      final progress = UserProgress(
        userId: 'test',
        completedPuzzles: [1],
        failedPuzzles: [2],
      );

      // Should return either 3 or 4
      final next = service.getNextPuzzle(puzzles, progress);
      expect(next?.id, anyOf(3, 4));
    });

    test('selects from failed puzzles if all are attempted', () {
      final service = PuzzleQueueService();
      final progress = UserProgress(
        userId: 'test',
        completedPuzzles: [1, 3, 4],
        failedPuzzles: [2],
      );

      // Should return 2
      final next = service.getNextPuzzle(puzzles, progress);
      expect(next?.id, 2);
    });

    test('falls back to random if all are completed', () {
      final service = PuzzleQueueService();
      final progress = UserProgress(
        userId: 'test',
        completedPuzzles: [1, 2, 3, 4],
        failedPuzzles: [],
      );

      final next = service.getNextPuzzle(puzzles, progress);
      expect(next, isNotNull);
      expect(puzzles.map((p) => p.id), contains(next?.id));
    });

    test('returns null if puzzles list is empty', () {
      final service = PuzzleQueueService();
      final progress = UserProgress.empty('test');

      final next = service.getNextPuzzle<MockPuzzle>([], progress);
      expect(next, isNull);
    });
  });
}
