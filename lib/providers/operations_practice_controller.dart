import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/answer_normalizer.dart';

class OperationsPracticeState {
  const OperationsPracticeState({
    this.currentInput = '',
    this.isCorrect,
    this.hasSubmitted = false,
  });

  final String currentInput;
  final bool? isCorrect;
  final bool hasSubmitted;

  OperationsPracticeState copyWith({
    String? currentInput,
    bool? isCorrect,
    bool? hasSubmitted,
    bool clearIsCorrect = false,
  }) {
    return OperationsPracticeState(
      currentInput: currentInput ?? this.currentInput,
      isCorrect: clearIsCorrect ? null : isCorrect ?? this.isCorrect,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
    );
  }
}

final operationsPracticeControllerProvider =
    NotifierProvider<OperationsPracticeController, OperationsPracticeState>(
      OperationsPracticeController.new,
    );

class OperationsPracticeController extends Notifier<OperationsPracticeState> {
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

  void checkAnswer(String correctAnswer) {
    final isCorrect =
        AnswerNormalizer.normalize(state.currentInput) ==
        AnswerNormalizer.normalize(correctAnswer);

    state = state.copyWith(isCorrect: isCorrect, hasSubmitted: true);
  }

  void reset() {
    state = const OperationsPracticeState();
  }
}
