import 'package:cs_app/services/database_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fetchPuzzlesByType returns only active matching puzzle types', () async {
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

    expect(puzzles, hasLength(1));
    expect(puzzles.first.id, 101);
    expect(puzzles.first.type, 'loop_tracing');
    expect(puzzles.first.answer, '3');
  });

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
}
