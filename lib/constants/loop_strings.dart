class LoopStrings {
  const LoopStrings._();

  static const screenTitle = 'Loop Scout';
  static const sectionTitle = 'Loop tracing';
  static const loadingErrorTitle =
      'We could not load loop challenges right now.';
  static const loadingErrorSubtitle = 'Please try again in a moment.';
  static const noChallengesAvailable =
      'No loop challenges available right now.';
  static const noValidChallengesAvailable =
      'No valid loop challenges available right now.';
  static const malformedChallengesSkipped =
      'Some malformed challenges were skipped.';
  static const randomButton = 'Random';
  static const nextChallengeButton = 'Next Challenge';
  static const checkAnswerButton = 'Check Answer';
  static const answerLabel = 'Your answer';
  static const answerHint = 'Enter final value';
  static const answerHelper = 'Case and extra spaces are ignored.';
  static const emptyAnswerValidation =
      'Please enter an answer before checking.';
  static const successAnswer = 'Success! Correct answer.';

  static String challengeCount(int count) => '$count challenge(s) loaded.';
  static String retryPoolCount(int count) => 'Retry pool: $count';
  static String targetVariable(String value) => 'Target variable: $value';
  static String incorrectAnswer(String correctAnswer) =>
      'Not quite. Correct answer: $correctAnswer';
  static String difficultyLabel(int difficulty) => 'Difficulty: $difficulty';
  static String tagsLabel(List<String> tags) =>
      tags.isEmpty ? 'Tags: none' : 'Tags: ${tags.join(', ')}';
}
