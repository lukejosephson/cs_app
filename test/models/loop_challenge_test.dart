import 'package:cs_app/models/loop_challenge.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromMap builds model with Firestore schema keys', () {
    final challenge = LoopChallenge.fromMap({
      'id': 12,
      'type': 'loop_tracing',
      'snippet': 'for (var i = 0; i < 3; i++) { sum += i; }',
      'target': 'sum',
      'answer': '3',
      'error_line': 2,
      'difficulty': 1,
      'is_archived': false,
      'tags': ['for-loop', 'variables'],
    });

    expect(challenge.id, 12);
    expect(challenge.type, 'loop_tracing');
    expect(challenge.snippet, contains('for'));
    expect(challenge.target, 'sum');
    expect(challenge.answer, '3');
    expect(challenge.errorLine, 2);
    expect(challenge.difficulty, 1);
    expect(challenge.isArchived, isFalse);
    expect(challenge.tags, ['for-loop', 'variables']);
  });

  test('toMap preserves Firestore field names', () {
    const challenge = LoopChallenge(
      id: 7,
      type: 'error_detection',
      snippet: 'print(value)',
      target: 'value',
      answer: 'Undefined variable',
      errorLine: 1,
      difficulty: 2,
      isArchived: true,
      tags: ['syntax', 'dart'],
    );

    expect(challenge.toMap(), {
      'id': 7,
      'type': 'error_detection',
      'snippet': 'print(value)',
      'target': 'value',
      'answer': 'Undefined variable',
      'error_line': 1,
      'difficulty': 2,
      'is_archived': true,
      'tags': ['syntax', 'dart'],
    });
  });
}
