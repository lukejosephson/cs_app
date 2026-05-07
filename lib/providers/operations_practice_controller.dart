import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/operations_practice_challenge.dart';
import '../models/practice_state.dart';
import '../utils/answer_normalizer.dart';
import 'base_practice_controller.dart';

class OperationsPracticeState implements PracticeState {
  const OperationsPracticeState({
    this.currentInput = '',
    this.isCorrect,
    this.hasSubmitted = false,
    this.currentPuzzleIndex = 0,
  });

  final String currentInput;
  final bool? isCorrect;
  final bool hasSubmitted;
  @override
  final int currentPuzzleIndex;

  OperationsPracticeState copyWith({
    String? currentInput,
    bool? isCorrect,
    bool? hasSubmitted,
    int? currentPuzzleIndex,
    bool clearIsCorrect = false,
  }) {
    return OperationsPracticeState(
      currentInput: currentInput ?? this.currentInput,
      isCorrect: clearIsCorrect ? null : isCorrect ?? this.isCorrect,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      currentPuzzleIndex: currentPuzzleIndex ?? this.currentPuzzleIndex,
    );
  }
}

final operationsPracticeControllerProvider =
    NotifierProvider<OperationsPracticeController, OperationsPracticeState>(
      OperationsPracticeController.new,
    );

class OperationsPracticeController
    extends BasePracticeController<OperationsPracticeState> {
  @override
  OperationsPracticeState build() {
    return const OperationsPracticeState();
  }

  void updateInput(String input) {
    state = state.copyWith(
      currentInput: input,
      hasSubmitted: false,
      clearIsCorrect: true,
    );
  }

  Future<void> checkAnswer({
    required int puzzleId,
    required String correctAnswer,
  }) async {
    final isCorrect =
        AnswerNormalizer.normalize(state.currentInput) ==
        AnswerNormalizer.normalize(correctAnswer);

    state = state.copyWith(isCorrect: isCorrect, hasSubmitted: true);
    await updateProgress(puzzleId: puzzleId, isCorrect: isCorrect);
  }

  void moveToNextPuzzle(List<OperationsPracticeChallenge> puzzles) {
    final nextIndex = getNextPuzzleIndex(puzzles);
    state = state.copyWith(
      currentPuzzleIndex: nextIndex,
      currentInput: '',
      hasSubmitted: false,
      clearIsCorrect: true,
    );
  }

  void reset() {
    state = const OperationsPracticeState();
  }
}
