class AnswerNormalizer {
  const AnswerNormalizer._();

  static String normalize(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
  }
}
