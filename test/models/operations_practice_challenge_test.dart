import 'package:cs_app/models/operations_practice_challenge.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromMap builds model with Firestore schema keys', () {
    final challenge = OperationsPracticeChallenge.fromMap({
      'id': 34,
      'type': 'operations_practice',
      'snippet': 'x = 3 + 4 * 2',
      'error_line': 0,
      'target': 'What is x?',
      'answer': '11',
      'difficulty': 1,
      'is_archived': false,
      'tags': ['order-of-operations', 'arithmetic'],
    });

    expect(challenge.id, 34);
    expect(challenge.type, 'operations_practice');
    expect(challenge.snippet, 'x = 3 + 4 * 2');
    expect(challenge.errorLine, 0);
    expect(challenge.target, 'What is x?');
    expect(challenge.answer, '11');
    expect(challenge.difficulty, 1);
    expect(challenge.isArchived, isFalse);
    expect(challenge.tags, ['order-of-operations', 'arithmetic']);
  });

  test('toMap preserves Firestore field names', () {
    const challenge = OperationsPracticeChallenge(
      id: 9,
      type: 'operations_practice',
      snippet: 'result = 10 / 2 + 3',
      errorLine: 0,
      target: 'result',
      answer: '8',
      difficulty: 2,
      isArchived: true,
      tags: ['division'],
    );

    expect(challenge.toMap(), {
      'id': 9,
      'type': 'operations_practice',
      'snippet': 'result = 10 / 2 + 3',
      'error_line': 0,
      'target': 'result',
      'answer': '8',
      'difficulty': 2,
      'is_archived': true,
      'tags': ['division'],
    });
  });

  test('fromFirestore builds model from document snapshot', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('operations_practice').doc('77').set({
      OperationsPracticeChallenge.fieldType: 'operations_practice',
      OperationsPracticeChallenge.fieldSnippet: 'x = 2 ** 3',
      OperationsPracticeChallenge.fieldErrorLine: 0,
      OperationsPracticeChallenge.fieldTarget: 'x',
      OperationsPracticeChallenge.fieldAnswer: '8',
      OperationsPracticeChallenge.fieldDifficulty: 1,
      OperationsPracticeChallenge.fieldIsArchived: false,
      OperationsPracticeChallenge.fieldTags: ['exponents'],
    });

    final snapshot = await firestore
        .collection('operations_practice')
        .doc('77')
        .get();
    final challenge = OperationsPracticeChallenge.fromFirestore(snapshot);

    expect(challenge.id, 77);
    expect(challenge.type, 'operations_practice');
    expect(challenge.answer, '8');
    expect(challenge.tags, ['exponents']);
  });
}
