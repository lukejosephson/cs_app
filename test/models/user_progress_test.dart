import 'package:cs_app/models/user_progress.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProgress', () {
    test('empty factory creates initial state', () {
      const userId = 'user-123';
      final progress = UserProgress.empty(userId);

      expect(progress.userId, userId);
      expect(progress.completedPuzzles, isEmpty);
      expect(progress.failedPuzzles, isEmpty);
    });

    test('fromMap parses valid data', () {
      final map = {
        'userId': 'user-123',
        'completedPuzzles': [1, 2, 3],
        'failedPuzzles': [4, 5],
      };

      final progress = UserProgress.fromMap(map);

      expect(progress.userId, 'user-123');
      expect(progress.completedPuzzles, [1, 2, 3]);
      expect(progress.failedPuzzles, [4, 5]);
    });

    test('fromMap handles missing or null fields gracefully', () {
      final map = <String, dynamic>{};

      final progress = UserProgress.fromMap(map);

      expect(progress.userId, '');
      expect(progress.completedPuzzles, isEmpty);
      expect(progress.failedPuzzles, isEmpty);
    });

    test('fromMap handles different numeric types for puzzle IDs', () {
      final map = {
        'completedPuzzles': [1.0, 2],
        'failedPuzzles': [3.14], // Should be cast to int
      };

      final progress = UserProgress.fromMap(map);

      expect(progress.completedPuzzles, [1, 2]);
      expect(progress.failedPuzzles, [3]);
    });

    test('toMap returns correct map representation', () {
      const progress = UserProgress(
        userId: 'user-123',
        completedPuzzles: [10, 20],
        failedPuzzles: [30],
      );

      final map = progress.toMap();

      expect(map['userId'], 'user-123');
      expect(map['completedPuzzles'], [10, 20]);
      expect(map['failedPuzzles'], [30]);
    });
  });
}
