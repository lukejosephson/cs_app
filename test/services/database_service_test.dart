import 'package:cs_app/models/user_progress.dart';
import 'package:cs_app/services/database_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'fetchPuzzlesByType returns matching puzzle types regardless of archive state',
    () async {
      final firestore = FakeFirebaseFirestore();
      final service = FirestoreDatabaseService(firestore: firestore);

      await firestore.collection('puzzles').doc('101').set({
        'type': 'loop_tracing',
        'snippet': 'for (var i = 0; i < 3; i++) { total += i; }',
        'target': 'total',
        'answer': '3',
        'error_line': 0,
        'difficulty': 1,
        'is_archived': false,
        'tags': ['loop'],
      });

      await firestore.collection('puzzles').doc('102').set({
        'type': 'error_detection',
        'snippet': 'print(total)',
        'target': 'total',
        'answer': 'Undefined variable',
        'error_line': 1,
        'difficulty': 1,
        'is_archived': false,
        'tags': ['error'],
      });

      await firestore.collection('puzzles').doc('103').set({
        'type': 'loop_tracing',
        'snippet': 'for (var i = 0; i < 1; i++) { total += i; }',
        'target': 'total',
        'answer': '0',
        'error_line': 0,
        'difficulty': 1,
        'is_archived': true,
        'tags': ['loop'],
      });

      final puzzles = await service.fetchPuzzlesByType('loop_tracing');

      expect(puzzles, hasLength(2));
      expect(puzzles.map((p) => p.id), containsAll([101, 103]));
      expect(puzzles.where((p) => p.type == 'loop_tracing').length, equals(2));
    },
  );

  test('fetchPuzzlesByType throws when type is empty', () async {
    final firestore = FakeFirebaseFirestore();
    final service = FirestoreDatabaseService(firestore: firestore);

    expect(
      () => service.fetchPuzzlesByType('   '),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('getLoopPuzzles returns only active loop_scout puzzles', () async {
    final firestore = FakeFirebaseFirestore();
    final service = FirestoreDatabaseService(firestore: firestore);

    await firestore.collection('puzzles').doc('201').set({
      'type': 'loop_scout',
      'snippet': 'for (var i = 0; i < 3; i++) { total += i; }',
      'target': 'total',
      'answer': '3',
      'error_line': 0,
      'difficulty': 1,
      'is_archived': false,
      'tags': ['loop'],
    });

    await firestore.collection('puzzles').doc('202').set({
      'type': 'loop_scout',
      'snippet': 'for (var i = 0; i < 2; i++) { total += i; }',
      'target': 'total',
      'answer': '1',
      'error_line': 0,
      'difficulty': 1,
      'is_archived': true,
      'tags': ['loop'],
    });

    await firestore.collection('puzzles').doc('203').set({
      'type': 'error_detection',
      'snippet': 'print(total)',
      'target': 'total',
      'answer': 'Undefined variable',
      'error_line': 1,
      'difficulty': 1,
      'is_archived': false,
      'tags': ['error'],
    });

    final puzzles = await service.getLoopPuzzles().first;

    expect(puzzles, hasLength(1));
    expect(puzzles.first.id, 201);
    expect(puzzles.first.type, 'loop_scout');
    expect(puzzles.first.isArchived, isFalse);
  });

  test('fetchLoopPuzzles returns only active loop_scout puzzles', () async {
    final firestore = FakeFirebaseFirestore();
    final service = FirestoreDatabaseService(firestore: firestore);

    await firestore.collection('puzzles').doc('301').set({
      'type': 'loop_scout',
      'snippet': 'for (var i = 0; i < 2; i++) { sum += i; }',
      'target': 'sum',
      'answer': '1',
      'error_line': 0,
      'difficulty': 1,
      'is_archived': false,
      'tags': ['loop'],
    });

    await firestore.collection('puzzles').doc('302').set({
      'type': 'loop_scout',
      'snippet': 'for (var i = 0; i < 1; i++) { sum += i; }',
      'target': 'sum',
      'answer': '0',
      'error_line': 0,
      'difficulty': 1,
      'is_archived': true,
      'tags': ['loop'],
    });

    final puzzles = await service.fetchLoopPuzzles();

    expect(puzzles, hasLength(1));
    expect(puzzles.first.id, 301);
    expect(puzzles.first.type, 'loop_scout');
    expect(puzzles.first.isArchived, isFalse);
  });

  test('fetchLoopPuzzles excludes malformed loop_scout records', () async {
    final firestore = FakeFirebaseFirestore();
    final service = FirestoreDatabaseService(firestore: firestore);

    await firestore.collection('puzzles').doc('401').set({
      'type': 'loop_scout',
      'snippet': 'for (var i = 0; i < 2; i++) { sum += i; }',
      'target': 'sum',
      'answer': '1',
      'error_line': 0,
      'difficulty': 1,
      'is_archived': false,
      'tags': ['loop'],
    });

    await firestore.collection('puzzles').doc('402').set({
      'type': 'loop_scout',
      'snippet': '',
      'target': 'sum',
      'answer': '',
      'error_line': 0,
      'difficulty': 1,
      'is_archived': false,
      'tags': ['loop'],
    });

    final puzzles = await service.fetchLoopPuzzles();

    expect(puzzles, hasLength(1));
    expect(puzzles.first.id, 401);
  });

  test(
    'fetchErrorDetectionPuzzles returns only active error_detection puzzles',
    () async {
      final firestore = FakeFirebaseFirestore();
      final service = FirestoreDatabaseService(firestore: firestore);

      await firestore.collection('puzzles').doc('501').set({
        'type': 'error_detection',
        'snippet': 'if (x = 1) { print(x); }',
        'error_line': 1,
        'target': 'Assignment in conditional',
        'answer':
            "Use '==' for comparison; '=' performs assignment in the condition.",
        'difficulty': 2,
        'is_archived': false,
        'tags': ['assignment', 'condition'],
      });

      await firestore.collection('puzzles').doc('502').set({
        'type': 'error_detection',
        'snippet': 'while (i < 10) { i++; }',
        'error_line': 0,
        'target': 'Archived puzzle',
        'answer': 'Archived puzzle explanation',
        'difficulty': 1,
        'is_archived': true,
        'tags': ['loop'],
      });

      await firestore.collection('puzzles').doc('503').set({
        'type': 'loop_scout',
        'snippet': 'for (var i = 0; i < 2; i++) { sum += i; }',
        'target': 'sum',
        'answer': '1',
        'error_line': 0,
        'difficulty': 1,
        'is_archived': false,
        'tags': ['loop'],
      });

      final puzzles = await service.fetchErrorDetectionPuzzles();

      expect(puzzles, hasLength(1));
      expect(puzzles.first.id, 501);
      expect(puzzles.first.type, 'error_detection');
      expect(puzzles.first.errorLine, 1);
      expect(puzzles.first.isArchived, isFalse);
      expect(puzzles.first.tags, ['assignment', 'condition']);
      expect(
        puzzles.first.answer,
        "Use '==' for comparison; '=' performs assignment in the condition.",
      );
    },
  );

  test('fetchErrorDetectionPuzzles excludes malformed records', () async {
    final firestore = FakeFirebaseFirestore();
    final service = FirestoreDatabaseService(firestore: firestore);

    await firestore.collection('puzzles').doc('601').set({
      'type': 'error_detection',
      'snippet': 'if (x = 1) { print(x); }',
      'error_line': 0,
      'target': 'Assignment in conditional',
      'answer': "Use '==' for comparison.",
      'difficulty': 1,
      'is_archived': false,
      'tags': ['condition'],
    });

    await firestore.collection('puzzles').doc('602').set({
      'type': 'error_detection',
      'snippet': 'if (x = 1) { print(x); }',
      'error_line': 0,
      'target': '',
      'answer': '',
      'difficulty': 1,
      'is_archived': false,
      'tags': ['condition'],
    });

    final puzzles = await service.fetchErrorDetectionPuzzles();

    expect(puzzles, hasLength(1));
    expect(puzzles.first.id, 601);
  });

  test(
    'fetchOperationsPuzzles returns only active operations puzzles',
    () async {
      final firestore = FakeFirebaseFirestore();
      final service = FirestoreDatabaseService(firestore: firestore);

      await firestore.collection('puzzles').doc('701').set({
        'type': 'operations_practice',
        'snippet': 'x = 3 + 4 * 2',
        'error_line': 0,
        'target': 'x',
        'answer': '11',
        'difficulty': 1,
        'is_archived': false,
        'tags': ['order-of-operations'],
      });

      await firestore.collection('puzzles').doc('702').set({
        'id': 702,
        'type': 'operations_practice',
        'snippet': 'x = (3 + 4) * 2',
        'error_line': 0,
        'target': 'x',
        'answer': '14',
        'difficulty': 1,
        'is_archived': true,
        'tags': ['parentheses'],
      });

      await firestore.collection('puzzles').doc('703').set({
        'type': 'loop_scout',
        'snippet': 'for i in range(3): total += i',
        'error_line': 0,
        'target': 'total',
        'answer': '3',
        'difficulty': 1,
        'is_archived': false,
        'tags': ['loop'],
      });

      final puzzles = await service.fetchOperationsPuzzles();

      expect(puzzles, hasLength(1));
      expect(puzzles.first.id, 701);
      expect(puzzles.first.type, 'operations_practice');
      expect(puzzles.first.isArchived, isFalse);
    },
  );

  group('UserProgress', () {
    test('getUserProgress returns empty progress if document does not exist', () async {
      final firestore = FakeFirebaseFirestore();
      final service = FirestoreDatabaseService(firestore: firestore);

      final progress = await service.getUserProgress('non-existent-user');

      expect(progress.userId, 'non-existent-user');
      expect(progress.completedPuzzles, isEmpty);
      expect(progress.failedPuzzles, isEmpty);
    });

    test('getUserProgress returns existing progress', () async {
      final firestore = FakeFirebaseFirestore();
      final service = FirestoreDatabaseService(firestore: firestore);

      await firestore.collection('users').doc('user-123').set({
        'userId': 'user-123',
        'completedPuzzles': [1, 2],
        'failedPuzzles': [3],
      });

      final progress = await service.getUserProgress('user-123');

      expect(progress.userId, 'user-123');
      expect(progress.completedPuzzles, [1, 2]);
      expect(progress.failedPuzzles, [3]);
    });

    test('getUserProgress throws when uid is empty', () async {
      final firestore = FakeFirebaseFirestore();
      final service = FirestoreDatabaseService(firestore: firestore);

      expect(
        () => service.getUserProgress('   '),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('updateUserProgress saves data to users collection', () async {
      final firestore = FakeFirebaseFirestore();
      final service = FirestoreDatabaseService(firestore: firestore);
      final progress = UserProgress(
        userId: 'user-123',
        completedPuzzles: [101],
        failedPuzzles: [102],
      );

      await service.updateUserProgress(progress);

      final snapshot =
          await firestore.collection('users').doc('user-123').get();
      expect(snapshot.exists, isTrue);
      expect(snapshot.data()?['completedPuzzles'], [101]);
      expect(snapshot.data()?['failedPuzzles'], [102]);
    });
  });
}
