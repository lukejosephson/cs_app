import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final loopRandomProvider = Provider<Random>((ref) => Random());

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
      wrongAttemptsByPuzzle: wrongAttemptsByPuzzle ?? this.wrongAttemptsByPuzzle,
      retryPuzzleIds: retryPuzzleIds ?? this.retryPuzzleIds,
    );
  }
}

final loopTracingControllerProvider =
    NotifierProvider<LoopTracingController, LoopTracingState>(
      LoopTracingController.new,
    );

class LoopTracingController extends Notifier<LoopTracingState> {
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

  void submitAnswer({required int puzzleId, required String expectedAnswer}) {
    final userInput = state.currentInput.trim();
    if (userInput.isEmpty) {
      state = state.copyWith(
        isCorrect: false,
        hasSubmitted: false,
        inputErrorMessage: 'Please enter an answer before checking.',
      );
      return;
    }

    final normalizedInput = _normalizeAnswer(userInput);
    final normalizedExpected = _normalizeAnswer(expectedAnswer);
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
  }

  void reset() {
    state = const LoopTracingState();
  }

  void clearResponse() {
    state = state.copyWith(
      currentInput: '',
      isCorrect: false,
      hasSubmitted: false,
      clearInputError: true,
    );
  }

  void moveToNextPuzzle(int puzzleCount) {
    if (puzzleCount <= 0) {
      return;
    }

    final nextIndex = (state.currentPuzzleIndex + 1) % puzzleCount;
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

    final random = ref.read(loopRandomProvider);
    var nextIndex = state.currentPuzzleIndex;
    if (puzzleCount > 1) {
      while (nextIndex == state.currentPuzzleIndex) {
        nextIndex = random.nextInt(puzzleCount);
      }
    }

    state = state.copyWith(
      currentPuzzleIndex: nextIndex,
      currentInput: '',
      isCorrect: false,
      hasSubmitted: false,
      clearInputError: true,
    );
  }

  String _normalizeAnswer(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
  }
}

typedef LoopScoutController = LoopTracingController;

final loopScoutControllerProvider = loopTracingControllerProvider;
