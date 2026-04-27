import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/binary_practice_config.dart';
import '../models/binary_practice_state.dart';

final randomProvider = Provider<Random>((ref) => Random());
final sharedPreferencesProvider = Provider<SharedPreferences?>((ref) => null);

final binaryPracticeProvider =
    StateNotifierProvider<BinaryPracticeController, BinaryPracticeState>((ref) {
      return BinaryPracticeController(
        ref.watch(randomProvider),
        ref.watch(sharedPreferencesProvider),
      );
    });

class BinaryPracticeController extends StateNotifier<BinaryPracticeState> {
  BinaryPracticeController(this._random, this._prefs)
    : super(
        BinaryPracticeState.initial(
          _random.nextInt(1 << BinaryPracticeConfig.bitCount),
        ),
      );

  final Random _random;
  final SharedPreferences? _prefs;

  static const _showCurrentValueKey = 'binary.showCurrentValue';
  static const _showBitPlaceValuesKey = 'binary.showBitPlaceValues';

  void restoreDisplayPreferences() {
    final prefs = _prefs;
    if (prefs == null) {
      return;
    }
    state = state.copyWith(
      showCurrentValue:
          prefs.getBool(_showCurrentValueKey) ?? state.showCurrentValue,
      showBitPlaceValues:
          prefs.getBool(_showBitPlaceValuesKey) ?? state.showBitPlaceValues,
    );
  }

  void toggleBit(int index) {
    final updatedBits = List<bool>.from(state.bits);
    updatedBits[index] = !updatedBits[index];
    state = state.copyWith(bits: updatedBits, clearFeedback: true);
  }

  void checkAnswer() {
    final answeredNumber = state.targetNumber;
    final answeredBinary = answeredNumber
        .toRadixString(2)
        .padLeft(BinaryPracticeConfig.bitCount, '0');

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
    _prefs?.setBool(_showCurrentValueKey, value);
  }

  void toggleShowBitPlaceValues(bool value) {
    state = state.copyWith(showBitPlaceValues: value);
    _prefs?.setBool(_showBitPlaceValuesKey, value);
  }
}
