import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorDetectionState {
  const ErrorDetectionState({
    this.selectedLineIndex,
    this.hasSubmitted = false,
    this.isCorrect,
  });

  final int? selectedLineIndex;
  final bool hasSubmitted;
  final bool? isCorrect;

  ErrorDetectionState copyWith({
    int? selectedLineIndex,
    bool? hasSubmitted,
    bool? isCorrect,
    bool clearSelection = false,
    bool clearCorrectness = false,
  }) {
    return ErrorDetectionState(
      selectedLineIndex: clearSelection
          ? null
          : selectedLineIndex ?? this.selectedLineIndex,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      isCorrect: clearCorrectness ? null : isCorrect ?? this.isCorrect,
    );
  }
}

final errorDetectionControllerProvider =
    NotifierProvider<ErrorDetectionController, ErrorDetectionState>(
      ErrorDetectionController.new,
    );

class ErrorDetectionController extends Notifier<ErrorDetectionState> {
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

  void checkSelection(int correctLineIndex) {
    state = state.copyWith(
      hasSubmitted: true,
      isCorrect: state.selectedLineIndex == correctLineIndex,
    );
  }
}
