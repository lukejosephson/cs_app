import 'package:cs_app/models/error_detection_challenge.dart';
import 'package:cs_app/models/loop_challenge.dart';
import 'package:cs_app/models/operations_practice_challenge.dart';
import 'package:cs_app/providers/loop_provider.dart';
import 'package:cs_app/providers/operations_practice_provider.dart';
import 'package:cs_app/services/database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDatabaseService implements DatabaseService {
  const _FakeDatabaseService(this._operationsPuzzles);

  final List<OperationsPracticeChallenge> _operationsPuzzles;

  @override
  Future<List<LoopChallenge>> fetchPuzzlesByType(String type) async => const [];

  @override
  Future<List<LoopChallenge>> fetchLoopPuzzles() async => const [];

  @override
  Future<List<ErrorDetectionChallenge>> fetchErrorDetectionPuzzles() async =>
      const [];

  @override
  Future<List<OperationsPracticeChallenge>> fetchOperationsPuzzles() async =>
      _operationsPuzzles;

  @override
  Stream<List<LoopChallenge>> getLoopPuzzles() => const Stream.empty();
}

void main() {
  test('operationsPracticeProvider returns operations puzzle data', () async {
    const sample = OperationsPracticeChallenge(
      id: 1,
      type: 'operations_practice',
      snippet: 'x = 3 + 4 * 2',
      errorLine: 0,
      target: 'What is x?',
      answer: '11',
      difficulty: 1,
      isArchived: false,
      tags: ['order-of-operations'],
    );

    final container = ProviderContainer(
      overrides: [
        databaseServiceProvider.overrideWithValue(
          const _FakeDatabaseService([sample]),
        ),
      ],
    );
    addTearDown(container.dispose);

    final puzzles = await container.read(operationsPracticeProvider.future);
    expect(puzzles, hasLength(1));
    expect(puzzles.first.id, 1);
    expect(puzzles.first.type, 'operations_practice');
  });
}
