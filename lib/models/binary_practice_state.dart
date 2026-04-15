class BinaryPracticeState {
  const BinaryPracticeState({
    required this.targetNumber,
    required this.bits,
    required this.feedback,
    required this.isCorrect,
    required this.showCurrentValue,
    required this.showBitPlaceValues,
  });

  factory BinaryPracticeState.initial(int targetNumber) {
    return BinaryPracticeState(
      targetNumber: targetNumber,
      bits: List<bool>.filled(7, false),
      feedback: null,
      isCorrect: null,
      showCurrentValue: true,
      showBitPlaceValues: true,
    );
  }

  final int targetNumber;
  final List<bool> bits;
  final String? feedback;
  final bool? isCorrect;
  final bool showCurrentValue;
  final bool showBitPlaceValues;

  BinaryPracticeState copyWith({
    int? targetNumber,
    List<bool>? bits,
    String? feedback,
    bool? isCorrect,
    bool? showCurrentValue,
    bool? showBitPlaceValues,
    bool clearFeedback = false,
  }) {
    return BinaryPracticeState(
      targetNumber: targetNumber ?? this.targetNumber,
      bits: bits ?? this.bits,
      feedback: clearFeedback ? null : feedback ?? this.feedback,
      isCorrect: clearFeedback ? null : isCorrect ?? this.isCorrect,
      showCurrentValue: showCurrentValue ?? this.showCurrentValue,
      showBitPlaceValues: showBitPlaceValues ?? this.showBitPlaceValues,
    );
  }

  int get currentValue {
    var total = 0;
    for (var index = 0; index < bits.length; index++) {
      if (bits[index]) {
        total += 1 << (bits.length - 1 - index);
      }
    }
    return total;
  }
}
