import 'package:cs_app/models/operations_practice_challenge.dart';
import 'package:cs_app/models/user_progress.dart';
import 'package:cs_app/providers/auth_provider.dart';
import 'package:cs_app/providers/loop_provider.dart';
import 'package:cs_app/providers/operations_practice_controller.dart';
import 'package:cs_app/providers/user_progress_provider.dart';
import 'package:cs_app/services/database_service.dart';
import 'package:cs_app/models/loop_challenge.dart';
import 'package:cs_app/models/error_detection_challenge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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

  test('operations practice state starts empty and unsubmitted', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = container.read(operationsPracticeControllerProvider);
    expect(state.currentInput, isEmpty);
    expect(state.isCorrect, isNull);
    expect(state.hasSubmitted, isFalse);
    expect(state.currentPuzzleIndex, 0);
  });

  test('updateInput updates input and clears previous submission state', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(
      operationsPracticeControllerProvider.notifier,
    );

    controller.updateInput('11');
    controller.updateInput('10');

    final state = container.read(operationsPracticeControllerProvider);
    expect(state.currentInput, '10');
    expect(state.isCorrect, isNull);
    expect(state.hasSubmitted, isFalse);
  });

  test('checkAnswer sets state correct and updates progress', () async {
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
    final controller = container.read(
      operationsPracticeControllerProvider.notifier,
    );

    controller.updateInput('  5  ');
    await controller.checkAnswer(puzzleId: 1, correctAnswer: '5');

    final state = container.read(operationsPracticeControllerProvider);
    expect(state.isCorrect, isTrue);
    expect(state.hasSubmitted, isTrue);
    expect(fakeDatabaseService.lastUpdatedProgress?.completedPuzzles, [1]);
  });

  test('checkAnswer sets state incorrect and updates progress', () async {
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
    final controller = container.read(
      operationsPracticeControllerProvider.notifier,
    );

    controller.updateInput('11');
    await controller.checkAnswer(puzzleId: 101, correctAnswer: '14');

    final state = container.read(operationsPracticeControllerProvider);
    expect(state.isCorrect, isFalse);
    expect(state.hasSubmitted, isTrue);
    expect(fakeDatabaseService.lastUpdatedProgress?.failedPuzzles, [101]);
  });

  test('reset clears state', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(
      operationsPracticeControllerProvider.notifier,
    );

    controller.updateInput('11');
    controller.reset();

    final state = container.read(operationsPracticeControllerProvider);
    expect(state.currentInput, isEmpty);
    expect(state.isCorrect, isNull);
    expect(state.hasSubmitted, isFalse);
  });

  test('moveToNextPuzzle uses selection algorithm', () async {
    final puzzles = [
      const OperationsPracticeChallenge(
        id: 1,
        type: 'operations_practice',
        snippet: 's1',
        target: 't1',
        answer: 'a1',
        difficulty: 1,
        errorLine: 0,
        isArchived: false,
        tags: [],
      ),
      const OperationsPracticeChallenge(
        id: 2,
        type: 'operations_practice',
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
    final controller = container.read(
      operationsPracticeControllerProvider.notifier,
    );

    expect(
      container.read(operationsPracticeControllerProvider).currentPuzzleIndex,
      0,
    );
    controller.moveToNextPuzzle(puzzles);
    expect(
      container.read(operationsPracticeControllerProvider).currentPuzzleIndex,
      1,
    );
  });
}
