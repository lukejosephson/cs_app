import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoopTracingState {
  const LoopTracingState({this.currentInput = '', this.isCorrect = false});

  final String currentInput;
  final bool isCorrect;

  LoopTracingState copyWith({String? currentInput, bool? isCorrect}) {
    return LoopTracingState(
      currentInput: currentInput ?? this.currentInput,
      isCorrect: isCorrect ?? this.isCorrect,
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
    state = state.copyWith(currentInput: input, isCorrect: false);
  }

  void submitAnswer(String expectedAnswer) {
    final userInput = state.currentInput.trim();
    final expected = expectedAnswer.trim();
    state = state.copyWith(
      isCorrect: userInput.isNotEmpty && userInput == expected,
    );
  }

  void reset() {
    state = const LoopTracingState();
  }
}
