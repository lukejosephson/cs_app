import 'dart:async';

import 'package:cs_app/models/error_detection_challenge.dart';
import 'package:cs_app/models/loop_challenge.dart';
import 'package:cs_app/providers/loop_provider.dart';
import 'package:cs_app/services/database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDatabaseService implements DatabaseService {
  _FakeDatabaseService(this._puzzles);

  final List<LoopChallenge> _puzzles;

  @override
  Future<List<LoopChallenge>> fetchLoopPuzzles() async => _puzzles;

  @override
  Future<List<LoopChallenge>> fetchPuzzlesByType(String type) async => _puzzles;

  @override
  Future<List<ErrorDetectionChallenge>> fetchErrorDetectionPuzzles() async =>
      const [];

  @override
  Stream<List<LoopChallenge>> getLoopPuzzles() => Stream.value(_puzzles);
}

void main() {
  const sampleChallenge = LoopChallenge(
    id: 1,
    type: 'loop_scout',
    snippet: 'for (var i = 0; i < 3; i++) { total += i; }',
    target: 'total',
    answer: '3',
    errorLine: 0,
    difficulty: 1,
    isArchived: false,
    tags: ['loop'],
  );

  test('loopPuzzlesProvider emits active loop puzzle stream data', () async {
    final container = ProviderContainer(
      overrides: [
        databaseServiceProvider.overrideWithValue(
          _FakeDatabaseService(const [sampleChallenge]),
        ),
      ],
    );
    addTearDown(container.dispose);

    final puzzles = await container.read(loopPuzzlesProvider.future);
    expect(puzzles, hasLength(1));
    expect(puzzles.first.id, 1);
    expect(puzzles.first.type, 'loop_scout');
  });

  test('loopPuzzlesOnceProvider fetches active loop puzzles once', () async {
    final container = ProviderContainer(
      overrides: [
        databaseServiceProvider.overrideWithValue(
          _FakeDatabaseService(const [sampleChallenge]),
        ),
      ],
    );
    addTearDown(container.dispose);

    final puzzles = await container.read(loopPuzzlesOnceProvider.future);
    expect(puzzles, hasLength(1));
    expect(puzzles.first.answer, '3');
  });
}
