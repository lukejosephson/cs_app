enum PracticeTypeId { binary, loopScout, errorDetection, operationsPractice }

class PracticeType {
  const PracticeType({
    required this.id,
    required this.title,
    required this.description,
  });

  final PracticeTypeId id;
  final String title;
  final String description;
}
