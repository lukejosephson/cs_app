import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final loopRandomProvider = Provider<Random>((ref) => Random());

class LoopTracingState {
  const LoopTracingState({
    this.currentInput = '',
    this.isCorrect = false,
    this.hasSubmitted = false,
    this.currentPuzzleIndex = 0,
  });

  final String currentInput;
  final bool isCorrect;
  final bool hasSubmitted;
  final int currentPuzzleIndex;

  LoopTracingState copyWith({
    String? currentInput,
    bool? isCorrect,
    bool? hasSubmitted,
    int? currentPuzzleIndex,
  }) {
    return LoopTracingState(
      currentInput: currentInput ?? this.currentInput,
      isCorrect: isCorrect ?? this.isCorrect,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      currentPuzzleIndex: currentPuzzleIndex ?? this.currentPuzzleIndex,
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
    );
  }

  void submitAnswer(String expectedAnswer) {
    final userInput = state.currentInput.trim();
    final expected = expectedAnswer.trim();
    state = state.copyWith(
      isCorrect: userInput.isNotEmpty && userInput == expected,
      hasSubmitted: true,
    );
  }

  void reset() {
    state = const LoopTracingState();
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
    );
  }
}

typedef LoopScoutController = LoopTracingController;

final loopScoutControllerProvider = loopTracingControllerProvider;
