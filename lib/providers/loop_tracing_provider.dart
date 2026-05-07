import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/loop_strings.dart';
import '../models/loop_challenge.dart';
import '../utils/answer_normalizer.dart';
import 'base_practice_controller.dart';

class LoopTracingState {
  const LoopTracingState({
    this.currentInput = '',
    this.isCorrect = false,
    this.hasSubmitted = false,
    this.currentPuzzleIndex = 0,
    this.inputErrorMessage,
    this.wrongAttemptsByPuzzle = const {},
    this.retryPuzzleIds = const [],
  });

  final String currentInput;
  final bool isCorrect;
  final bool hasSubmitted;
  final int currentPuzzleIndex;
  final String? inputErrorMessage;
  final Map<int, int> wrongAttemptsByPuzzle;
  final List<int> retryPuzzleIds;

  LoopTracingState copyWith({
    String? currentInput,
    bool? isCorrect,
    bool? hasSubmitted,
    int? currentPuzzleIndex,
    String? inputErrorMessage,
    Map<int, int>? wrongAttemptsByPuzzle,
    List<int>? retryPuzzleIds,
    bool clearInputError = false,
  }) {
    return LoopTracingState(
      currentInput: currentInput ?? this.currentInput,
      isCorrect: isCorrect ?? this.isCorrect,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      currentPuzzleIndex: currentPuzzleIndex ?? this.currentPuzzleIndex,
      inputErrorMessage: clearInputError
          ? null
          : inputErrorMessage ?? this.inputErrorMessage,
      wrongAttemptsByPuzzle:
          wrongAttemptsByPuzzle ?? this.wrongAttemptsByPuzzle,
      retryPuzzleIds: retryPuzzleIds ?? this.retryPuzzleIds,
    );
  }
}

final loopTracingControllerProvider =
    NotifierProvider<LoopTracingController, LoopTracingState>(
      LoopTracingController.new,
    );

class LoopTracingController extends BasePracticeController<LoopTracingState> {
  @override
  LoopTracingState build() {
    return const LoopTracingState();
  }

  void updateInput(String input) {
    state = state.copyWith(
      currentInput: input,
      isCorrect: false,
      hasSubmitted: false,
      clearInputError: true,
    );
  }

  Future<void> submitAnswer({
    required int puzzleId,
    required String expectedAnswer,
  }) async {
    final userInput = state.currentInput.trim();
    if (userInput.isEmpty) {
      state = state.copyWith(
        isCorrect: false,
        hasSubmitted: false,
        inputErrorMessage: LoopStrings.emptyAnswerValidation,
      );
      return;
    }

    final normalizedInput = AnswerNormalizer.normalize(userInput);
    final normalizedExpected = AnswerNormalizer.normalize(expectedAnswer);
    final isCorrect = normalizedInput == normalizedExpected;

    final wrongAttempts = Map<int, int>.from(state.wrongAttemptsByPuzzle);
    final retryIds = List<int>.from(state.retryPuzzleIds);
    if (!isCorrect) {
      wrongAttempts[puzzleId] = (wrongAttempts[puzzleId] ?? 0) + 1;
      if (!retryIds.contains(puzzleId)) {
        retryIds.add(puzzleId);
      }
    }

    state = state.copyWith(
      isCorrect: isCorrect,
      hasSubmitted: true,
      clearInputError: true,
      wrongAttemptsByPuzzle: wrongAttempts,
      retryPuzzleIds: retryIds,
    );

    await updateProgress(puzzleId: puzzleId, isCorrect: isCorrect);
  }

  void moveToNextPuzzle(List<LoopChallenge> puzzles) {
    final nextIndex = getNextPuzzleIndex(puzzles);
    state = state.copyWith(
      currentPuzzleIndex: nextIndex,
      currentInput: '',
      isCorrect: false,
      hasSubmitted: false,
      clearInputError: true,
    );
  }

  void moveToRandomPuzzle(int puzzleCount) {
    if (puzzleCount <= 0) {
      return;
    }
    final randomIndex = Random().nextInt(puzzleCount);
    state = state.copyWith(
      currentPuzzleIndex: randomIndex,
      currentInput: '',
      isCorrect: false,
      hasSubmitted: false,
      clearInputError: true,
    );
  }

  void clearResponse() {
    state = state.copyWith(
      currentInput: '',
      isCorrect: false,
      hasSubmitted: false,
      clearInputError: true,
    );
  }

  void reset() {
    state = const LoopTracingState();
  }
}

typedef LoopScoutController = LoopTracingController;

final loopScoutControllerProvider = loopTracingControllerProvider;
