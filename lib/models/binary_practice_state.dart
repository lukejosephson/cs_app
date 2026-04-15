class BinaryPracticeState {
  const BinaryPracticeState({
    required this.targetNumber,
    required this.bits,
    required this.feedback,
    required this.isCorrect,
  });

  factory BinaryPracticeState.initial(int targetNumber) {
    return BinaryPracticeState(
      targetNumber: targetNumber,
      bits: List<bool>.filled(6, false),
      feedback: null,
      isCorrect: null,
    );
  }

  final int targetNumber;
  final List<bool> bits;
  final String? feedback;
  final bool? isCorrect;

  BinaryPracticeState copyWith({
    int? targetNumber,
    List<bool>? bits,
    String? feedback,
    bool? isCorrect,
    bool clearFeedback = false,
  }) {
    return BinaryPracticeState(
      targetNumber: targetNumber ?? this.targetNumber,
      bits: bits ?? this.bits,
      feedback: clearFeedback ? null : feedback ?? this.feedback,
      isCorrect: clearFeedback ? null : isCorrect ?? this.isCorrect,
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
