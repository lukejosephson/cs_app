import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/error_detection_challenge.dart';
import '../models/practice_state.dart';
import 'base_practice_controller.dart';

class ErrorDetectionState implements PracticeState {
  const ErrorDetectionState({
    this.selectedLineIndex,
    this.hasSubmitted = false,
    this.isCorrect,
    this.currentPuzzleIndex = 0,
  });

  final int? selectedLineIndex;
  final bool hasSubmitted;
  final bool? isCorrect;
  @override
  final int currentPuzzleIndex;

  ErrorDetectionState copyWith({
    int? selectedLineIndex,
    bool? hasSubmitted,
    bool? isCorrect,
    int? currentPuzzleIndex,
    bool clearSelection = false,
    bool clearCorrectness = false,
  }) {
    return ErrorDetectionState(
      selectedLineIndex: clearSelection
          ? null
          : selectedLineIndex ?? this.selectedLineIndex,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      isCorrect: clearCorrectness ? null : isCorrect ?? this.isCorrect,
      currentPuzzleIndex: currentPuzzleIndex ?? this.currentPuzzleIndex,
    );
  }
}

final errorDetectionControllerProvider =
    NotifierProvider<ErrorDetectionController, ErrorDetectionState>(
      ErrorDetectionController.new,
    );

class ErrorDetectionController
    extends BasePracticeController<ErrorDetectionState> {
  @override
  ErrorDetectionState build() {
    return const ErrorDetectionState();
  }

  void selectLine(int index) {
    state = state.copyWith(
      selectedLineIndex: index,
      hasSubmitted: false,
      clearCorrectness: true,
    );
  }

  void selectLineNumber(int lineNumber) {
    selectLine(lineNumber - 1);
  }

  Future<void> checkSelection({
    required int puzzleId,
    required int correctLineIndex,
  }) async {
    final isCorrect = state.selectedLineIndex == correctLineIndex;
    state = state.copyWith(hasSubmitted: true, isCorrect: isCorrect);
    await updateProgress(puzzleId: puzzleId, isCorrect: isCorrect);
  }

  void moveToNextPuzzle(List<ErrorDetectionChallenge> puzzles) {
    final nextIndex = getNextPuzzleIndex(puzzles);
    state = state.copyWith(
      currentPuzzleIndex: nextIndex,
      selectedLineIndex: null,
      hasSubmitted: false,
      isCorrect: null,
      clearSelection: true,
      clearCorrectness: true,
    );
  }

  void reset() {
    state = const ErrorDetectionState();
  }
}
