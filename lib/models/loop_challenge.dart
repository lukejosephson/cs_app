import 'package:cloud_firestore/cloud_firestore.dart';

class LoopChallenge {
  static const fieldAnswer = 'answer';
  static const fieldDifficulty = 'difficulty';
  static const fieldErrorLine = 'error_line';
  static const fieldId = 'id';
  static const fieldIsArchived = 'is_archived';
  static const fieldSnippet = 'snippet';
  static const fieldTags = 'tags';
  static const fieldTarget = 'target';
  static const fieldType = 'type';

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

  factory LoopChallenge.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    final docIdAsInt = int.tryParse(snapshot.id);

    return LoopChallenge.fromMap({
      ...data,
      fieldId: (data[fieldId] as num?)?.toInt() ?? docIdAsInt ?? 0,
    });
  }

  factory LoopChallenge.fromMap(Map<String, dynamic> map) {
    return LoopChallenge(
      id: (map[fieldId] as num?)?.toInt() ?? 0,
      type: map[fieldType] as String? ?? '',
      snippet: map[fieldSnippet] as String? ?? '',
      target: map[fieldTarget] as String? ?? '',
      answer: map[fieldAnswer] as String? ?? '',
      errorLine: (map[fieldErrorLine] as num?)?.toInt() ?? 0,
      difficulty: (map[fieldDifficulty] as num?)?.toInt() ?? 0,
      isArchived: map[fieldIsArchived] as bool? ?? false,
      tags: (map[fieldTags] as List<dynamic>? ?? <dynamic>[])
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

  bool get hasRequiredPromptFields {
    return snippet.trim().isNotEmpty &&
        target.trim().isNotEmpty &&
        answer.trim().isNotEmpty;
  }

  Map<String, dynamic> toMap() {
    return {
      fieldId: id,
      fieldType: type,
      fieldSnippet: snippet,
      fieldTarget: target,
      fieldAnswer: answer,
      fieldErrorLine: errorLine,
      fieldDifficulty: difficulty,
      fieldIsArchived: isArchived,
      fieldTags: tags,
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
