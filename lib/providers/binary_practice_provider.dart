import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/binary_practice_state.dart';

final _randomProvider = Provider<Random>((ref) => Random());

final binaryPracticeProvider =
    StateNotifierProvider<BinaryPracticeController, BinaryPracticeState>((ref) {
      return BinaryPracticeController(ref.watch(_randomProvider));
    });

class BinaryPracticeController extends StateNotifier<BinaryPracticeState> {
  BinaryPracticeController(this._random) : super(BinaryPracticeState.initial(_random.nextInt(64)));

  final Random _random;

  void toggleBit(int index) {
    final updatedBits = List<bool>.from(state.bits);
    updatedBits[index] = !updatedBits[index];
    state = state.copyWith(bits: updatedBits, clearFeedback: true);
  }

  void checkAnswer() {
    if (state.currentValue == state.targetNumber) {
      state = BinaryPracticeState(
        targetNumber: _random.nextInt(64),
        bits: List<bool>.filled(6, false),
        feedback: 'Correct! Great work. Here is a new number.',
        isCorrect: true,
        showCurrentValue: state.showCurrentValue,
        showBitPlaceValues: state.showBitPlaceValues,
      );
      return;
    }

    state = state.copyWith(
      feedback:
          'Not quite. Correct answer: ${state.targetNumber.toRadixString(2).padLeft(6, '0')}',
      isCorrect: false,
    );
  }

  void toggleShowCurrentValue(bool value) {
    state = state.copyWith(showCurrentValue: value);
  }

  void toggleShowBitPlaceValues(bool value) {
    state = state.copyWith(showBitPlaceValues: value);
  }
}
