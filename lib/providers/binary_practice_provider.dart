import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/binary_practice_config.dart';
import '../models/binary_practice_state.dart';

final randomProvider = Provider<Random>((ref) => Random());

final binaryPracticeProvider =
    StateNotifierProvider<BinaryPracticeController, BinaryPracticeState>((ref) {
      return BinaryPracticeController(ref.watch(randomProvider));
    });

class BinaryPracticeController extends StateNotifier<BinaryPracticeState> {
  BinaryPracticeController(this._random)
      : super(BinaryPracticeState.initial(_random.nextInt(1 << BinaryPracticeConfig.bitCount)));

  final Random _random;

  void toggleBit(int index) {
    final updatedBits = List<bool>.from(state.bits);
    updatedBits[index] = !updatedBits[index];
    state = state.copyWith(bits: updatedBits, clearFeedback: true);
  }

  void checkAnswer() {
    final answeredNumber = state.targetNumber;
    final answeredBinary = answeredNumber.toRadixString(2).padLeft(BinaryPracticeConfig.bitCount, '0');

    if (state.currentValue == state.targetNumber) {
      state = BinaryPracticeState(
        targetNumber: _random.nextInt(1 << BinaryPracticeConfig.bitCount),
        bits: List<bool>.filled(BinaryPracticeConfig.bitCount, false),
        feedback:
            'Correct! The binary equivalent of $answeredNumber is $answeredBinary',
        isCorrect: true,
        showCurrentValue: state.showCurrentValue,
        showBitPlaceValues: state.showBitPlaceValues,
      );
      return;
    }

    state = state.copyWith(
      feedback:
          'Not quite. Correct answer: ${state.targetNumber.toRadixString(2).padLeft(BinaryPracticeConfig.bitCount, '0')}',
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
