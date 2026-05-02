import 'package:cs_app/models/error_detection_challenge.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromMap builds model with Firestore schema keys', () {
    final challenge = ErrorDetectionChallenge.fromMap({
      'id': 21,
      'type': 'error_detection',
      'snippet': 'print(total)',
      'error_line': 1,
      'target': 'total',
      'difficulty': 2,
      'is_archived': false,
      'tags': ['variables', 'scope'],
    });

    expect(challenge.id, 21);
    expect(challenge.type, 'error_detection');
    expect(challenge.snippet, 'print(total)');
    expect(challenge.errorLine, 1);
    expect(challenge.target, 'total');
    expect(challenge.difficulty, 2);
    expect(challenge.isArchived, isFalse);
    expect(challenge.tags, ['variables', 'scope']);
  });

  test('toMap preserves Firestore field names', () {
    const challenge = ErrorDetectionChallenge(
      id: 8,
      type: 'error_detection',
      snippet: 'print(value)',
      errorLine: 3,
      target: 'value',
      difficulty: 1,
      isArchived: true,
      tags: ['dart'],
    );

    expect(challenge.toMap(), {
      'id': 8,
      'type': 'error_detection',
      'snippet': 'print(value)',
      'error_line': 3,
      'target': 'value',
      'difficulty': 1,
      'is_archived': true,
      'tags': ['dart'],
    });
  });

  test('fromFirestore builds model from document snapshot', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('error_detection').doc('55').set({
      ErrorDetectionChallenge.fieldType: 'error_detection',
      ErrorDetectionChallenge.fieldSnippet: 'if (x = 1) { print(x); }',
      ErrorDetectionChallenge.fieldErrorLine: 1,
      ErrorDetectionChallenge.fieldTarget: 'x',
      ErrorDetectionChallenge.fieldDifficulty: 2,
      ErrorDetectionChallenge.fieldIsArchived: false,
      ErrorDetectionChallenge.fieldTags: ['assignment', 'condition'],
    });

    final snapshot = await firestore.collection('error_detection').doc('55').get();
    final challenge = ErrorDetectionChallenge.fromFirestore(snapshot);

    expect(challenge.id, 55);
    expect(challenge.type, 'error_detection');
    expect(challenge.errorLine, 1);
    expect(challenge.tags, ['assignment', 'condition']);
  });
}
