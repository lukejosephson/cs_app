import 'package:cs_app/models/loop_challenge.dart';
import 'package:cs_app/models/error_detection_challenge.dart';
import 'package:cs_app/models/operations_practice_challenge.dart';
import 'package:cs_app/models/user_progress.dart';
import 'package:cs_app/providers/auth_provider.dart';
import 'package:cs_app/providers/loop_provider.dart';
import 'package:cs_app/providers/loop_tracing_provider.dart';
import 'package:cs_app/providers/puzzle_queue_provider.dart';
import 'package:cs_app/providers/user_progress_provider.dart';
import 'package:cs_app/services/database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_random.dart';

class FakeDatabaseService implements DatabaseService {
  UserProgress? lastUpdatedProgress;

  @override
  Future<List<LoopChallenge>> fetchLoopPuzzles() async => [];
  @override
  Future<List<LoopChallenge>> fetchPuzzlesByType(String type) async => [];
  @override
  Future<List<ErrorDetectionChallenge>> fetchErrorDetectionPuzzles() async =>
      [];
  @override
  Future<List<OperationsPracticeChallenge>> fetchOperationsPuzzles() async =>
      [];
  @override
  Future<UserProgress> getUserProgress(String uid) async =>
      UserProgress.empty(uid);
  @override
  Stream<List<LoopChallenge>> getLoopPuzzles() => Stream.value([]);
  @override
  Future<void> updateUserProgress(UserProgress progress) async {
    lastUpdatedProgress = progress;
  }
}

void main() {
  late FakeDatabaseService fakeDatabaseService;

  setUp(() {
    fakeDatabaseService = FakeDatabaseService();
  });

  test('loop tracing state starts empty and incorrect', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = container.read(loopTracingControllerProvider);
    expect(state.currentInput, isEmpty);
    expect(state.isCorrect, isFalse);
    expect(state.hasSubmitted, isFalse);
    expect(state.currentPuzzleIndex, 0);
    expect(state.inputErrorMessage, isNull);
    expect(state.wrongAttemptsByPuzzle, isEmpty);
    expect(state.retryPuzzleIds, isEmpty);
  });

  test('updateInput updates input and clears correctness', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(loopTracingControllerProvider.notifier);

    controller.updateInput('42');
    expect(container.read(loopTracingControllerProvider).currentInput, '42');
    expect(container.read(loopTracingControllerProvider).isCorrect, isFalse);
    expect(container.read(loopTracingControllerProvider).hasSubmitted, isFalse);
    expect(
      container.read(loopTracingControllerProvider).inputErrorMessage,
      isNull,
    );
  });

  test('submitAnswer marks state correct and updates progress', () async {
    final container = ProviderContainer(
      overrides: [
        userIdProvider.overrideWithValue('user-123'),
        databaseServiceProvider.overrideWithValue(fakeDatabaseService),
        userProgressProvider.overrideWith(
          (ref) => UserProgress.empty('user-123'),
        ),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(loopTracingControllerProvider.notifier);

    controller.updateInput('  6 ');
    await controller.submitAnswer(puzzleId: 1, expectedAnswer: '6');

    expect(container.read(loopTracingControllerProvider).isCorrect, isTrue);
    expect(container.read(loopTracingControllerProvider).hasSubmitted, isTrue);

    // Verify database update
    expect(fakeDatabaseService.lastUpdatedProgress, isNotNull);
    expect(
      fakeDatabaseService.lastUpdatedProgress!.completedPuzzles,
      contains(1),
    );
  });

  test('submitAnswer marks state incorrect and updates progress', () async {
    final container = ProviderContainer(
      overrides: [
        userIdProvider.overrideWithValue('user-123'),
        databaseServiceProvider.overrideWithValue(fakeDatabaseService),
        userProgressProvider.overrideWith(
          (ref) => UserProgress.empty('user-123'),
        ),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(loopTracingControllerProvider.notifier);

    controller.updateInput('5');
    await controller.submitAnswer(puzzleId: 3, expectedAnswer: '6');

    expect(container.read(loopTracingControllerProvider).isCorrect, isFalse);
    expect(container.read(loopTracingControllerProvider).hasSubmitted, isTrue);

    // Verify database update
    expect(fakeDatabaseService.lastUpdatedProgress, isNotNull);
    expect(fakeDatabaseService.lastUpdatedProgress!.failedPuzzles, contains(3));
  });

  test('reset returns state to default values', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(loopTracingControllerProvider.notifier);

    controller.updateInput('6');
    controller.reset();

    final state = container.read(loopTracingControllerProvider);
    expect(state.currentInput, isEmpty);
    expect(state.isCorrect, isFalse);
    expect(state.hasSubmitted, isFalse);
    expect(state.currentPuzzleIndex, 0);
  });

  test('moveToNextPuzzle uses selection algorithm', () async {
    final puzzles = [
      const LoopChallenge(
        id: 1,
        type: 'loop_scout',
        snippet: 's1',
        target: 't1',
        answer: 'a1',
        difficulty: 1,
        errorLine: 0,
        isArchived: false,
        tags: [],
      ),
      const LoopChallenge(
        id: 2,
        type: 'loop_scout',
        snippet: 's2',
        target: 't2',
        answer: 'a2',
        difficulty: 1,
        errorLine: 0,
        isArchived: false,
        tags: [],
      ),
    ];

    final container = ProviderContainer(
      overrides: [
        userProgressProvider.overrideWith(
          (ref) => UserProgress(
            userId: 'u1',
            completedPuzzles: [1],
            failedPuzzles: [],
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(loopTracingControllerProvider.notifier);

    // Initially at index 0 (puzzle id 1)
    expect(container.read(loopTracingControllerProvider).currentPuzzleIndex, 0);

    // Move to next - should pick id 2 because id 1 is completed
    controller.moveToNextPuzzle(puzzles);

    expect(container.read(loopTracingControllerProvider).currentPuzzleIndex, 1);
  });

  test('moveToNextPuzzle still randomizes while progress is loading', () {
    final puzzles = [
      const LoopChallenge(
        id: 1,
        type: 'loop_scout',
        snippet: 's1',
        target: 't1',
        answer: 'a1',
        difficulty: 1,
        errorLine: 0,
        isArchived: false,
        tags: [],
      ),
      const LoopChallenge(
        id: 2,
        type: 'loop_scout',
        snippet: 's2',
        target: 't2',
        answer: 'a2',
        difficulty: 1,
        errorLine: 0,
        isArchived: false,
        tags: [],
      ),
      const LoopChallenge(
        id: 3,
        type: 'loop_scout',
        snippet: 's3',
        target: 't3',
        answer: 'a3',
        difficulty: 1,
        errorLine: 0,
        isArchived: false,
        tags: [],
      ),
    ];

    final container = ProviderContainer(
      overrides: [
        puzzleQueueServiceProvider.overrideWithValue(
          PuzzleQueueService(random: FakeRandom([2])),
        ),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(loopTracingControllerProvider.notifier);

    controller.moveToNextPuzzle(puzzles);

    expect(container.read(loopTracingControllerProvider).currentPuzzleIndex, 2);
  });
}
