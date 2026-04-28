import 'package:cs_app/services/database_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fetchPuzzlesByType returns only matching puzzle types', () async {
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

    final puzzles = await service.fetchPuzzlesByType('loop_tracing');

    expect(puzzles, hasLength(1));
    expect(puzzles.first.id, 101);
    expect(puzzles.first.type, 'loop_tracing');
    expect(puzzles.first.answer, '3');
  });
}
