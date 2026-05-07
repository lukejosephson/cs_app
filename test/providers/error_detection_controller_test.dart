import 'package:cs_app/models/error_detection_challenge.dart';
import 'package:cs_app/models/user_progress.dart';
import 'package:cs_app/providers/auth_provider.dart';
import 'package:cs_app/providers/error_detection_controller.dart';
import 'package:cs_app/providers/loop_provider.dart';
import 'package:cs_app/providers/user_progress_provider.dart';
import 'package:cs_app/services/database_service.dart';
import 'package:cs_app/models/loop_challenge.dart';
import 'package:cs_app/models/operations_practice_challenge.dart';
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

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        userIdProvider.overrideWithValue('user-123'),
        databaseServiceProvider.overrideWithValue(fakeDatabaseService),
        userProgressProvider.overrideWith(
          (ref) => UserProgress.empty('user-123'),
        ),
      ],
    );
  }

  test('error detection state starts with null selection and unsubmitted', () {
    final container = createContainer();
    addTearDown(container.dispose);

    final state = container.read(errorDetectionControllerProvider);
    expect(state.selectedLineIndex, isNull);
    expect(state.hasSubmitted, isFalse);
    expect(state.isCorrect, isNull);
    expect(state.currentPuzzleIndex, 0);
  });

  test('selectLine updates selection and clears correctness', () async {
    final container = createContainer();
    addTearDown(container.dispose);
    final controller = container.read(errorDetectionControllerProvider.notifier);

    controller.selectLine(2);
    expect(
      container.read(errorDetectionControllerProvider).selectedLineIndex,
      2,
    );

    await controller.checkSelection(puzzleId: 1, correctLineIndex: 2);
    expect(container.read(errorDetectionControllerProvider).isCorrect, isTrue);

    controller.selectLine(1);
    expect(
      container.read(errorDetectionControllerProvider).selectedLineIndex,
      1,
    );
    expect(container.read(errorDetectionControllerProvider).isCorrect, isNull);
    expect(
      container.read(errorDetectionControllerProvider).hasSubmitted,
      isFalse,
    );
  });

  test('checkSelection marks correct and updates progress', () async {
    final container = createContainer();
    addTearDown(container.dispose);
    final controller = container.read(errorDetectionControllerProvider.notifier);

    controller.selectLine(2);
    await controller.checkSelection(puzzleId: 1, correctLineIndex: 2);

    expect(container.read(errorDetectionControllerProvider).isCorrect, isTrue);
    expect(container.read(errorDetectionControllerProvider).hasSubmitted, isTrue);
    expect(fakeDatabaseService.lastUpdatedProgress?.completedPuzzles, [1]);
  });

  test('checkSelection marks incorrect and updates progress', () async {
    final container = createContainer();
    addTearDown(container.dispose);
    final controller = container.read(errorDetectionControllerProvider.notifier);

    controller.selectLine(1);
    await controller.checkSelection(puzzleId: 2, correctLineIndex: 2);

    expect(container.read(errorDetectionControllerProvider).isCorrect, isFalse);
    expect(container.read(errorDetectionControllerProvider).hasSubmitted, isTrue);
    expect(fakeDatabaseService.lastUpdatedProgress?.failedPuzzles, [2]);
  });

  test('moveToNextPuzzle uses selection algorithm', () async {
    final puzzles = [
      const ErrorDetectionChallenge(
        id: 1,
        type: 'error_detection',
        snippet: 's1',
        target: 't1',
        answer: 'a1',
        difficulty: 1,
        errorLine: 0,
        isArchived: false,
        tags: [],
      ),
      const ErrorDetectionChallenge(
        id: 2,
        type: 'error_detection',
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
            userId: 'user-123',
            completedPuzzles: [1],
            failedPuzzles: [],
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(errorDetectionControllerProvider.notifier);

    expect(
      container.read(errorDetectionControllerProvider).currentPuzzleIndex,
      0,
    );
    controller.moveToNextPuzzle(puzzles);
    expect(
      container.read(errorDetectionControllerProvider).currentPuzzleIndex,
      1,
    );
  });
}
