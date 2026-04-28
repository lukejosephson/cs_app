class LoopChallenge {
  const LoopChallenge({
    required this.id,
    required this.type,
    required this.snippet,
    required this.target,
    required this.answer,
    required this.errorLine,
    required this.difficulty,
    required this.isArchived,
    required this.tags,
  });

  factory LoopChallenge.fromMap(Map<String, dynamic> map) {
    return LoopChallenge(
      id: (map['id'] as num?)?.toInt() ?? 0,
      type: map['type'] as String? ?? '',
      snippet: map['snippet'] as String? ?? '',
      target: map['target'] as String? ?? '',
      answer: map['answer'] as String? ?? '',
      errorLine: (map['error_line'] as num?)?.toInt() ?? 0,
      difficulty: (map['difficulty'] as num?)?.toInt() ?? 0,
      isArchived: map['is_archived'] as bool? ?? false,
      tags: (map['tags'] as List<dynamic>? ?? <dynamic>[])
          .whereType<String>()
          .toList(growable: false),
    );
  }

  final int id;
  final String type;
  final String snippet;
  final String target;
  final String answer;
  final int errorLine;
  final int difficulty;
  final bool isArchived;
  final List<String> tags;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'snippet': snippet,
      'target': target,
      'answer': answer,
      'error_line': errorLine,
      'difficulty': difficulty,
      'is_archived': isArchived,
      'tags': tags,
    };
  }

  LoopChallenge copyWith({
    int? id,
    String? type,
    String? snippet,
    String? target,
    String? answer,
    int? errorLine,
    int? difficulty,
    bool? isArchived,
    List<String>? tags,
  }) {
    return LoopChallenge(
      id: id ?? this.id,
      type: type ?? this.type,
      snippet: snippet ?? this.snippet,
      target: target ?? this.target,
      answer: answer ?? this.answer,
      errorLine: errorLine ?? this.errorLine,
      difficulty: difficulty ?? this.difficulty,
      isArchived: isArchived ?? this.isArchived,
      tags: tags ?? this.tags,
    );
  }
}
