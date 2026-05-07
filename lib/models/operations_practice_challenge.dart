import 'package:cloud_firestore/cloud_firestore.dart';

class OperationsPracticeChallenge {
  static const fieldAnswer = 'answer';
  static const fieldDifficulty = 'difficulty';
  static const fieldErrorLine = 'error_line';
  static const fieldId = 'id';
  static const fieldIsArchived = 'is_archived';
  static const fieldSnippet = 'snippet';
  static const fieldTags = 'tags';
  static const fieldTarget = 'target';
  static const fieldType = 'type';

  const OperationsPracticeChallenge({
    required this.id,
    required this.type,
    required this.snippet,
    required this.errorLine,
    required this.target,
    required this.answer,
    required this.difficulty,
    required this.isArchived,
    required this.tags,
  });

  factory OperationsPracticeChallenge.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    final docIdAsInt = int.tryParse(snapshot.id);

    return OperationsPracticeChallenge.fromMap({
      ...data,
      fieldId: (data[fieldId] as num?)?.toInt() ?? docIdAsInt ?? 0,
    });
  }

  factory OperationsPracticeChallenge.fromMap(Map<String, dynamic> map) {
    return OperationsPracticeChallenge(
      id: (map[fieldId] as num?)?.toInt() ?? 0,
      type: map[fieldType] as String? ?? '',
      snippet: map[fieldSnippet] as String? ?? '',
      errorLine: (map[fieldErrorLine] as num?)?.toInt() ?? 0,
      target: map[fieldTarget] as String? ?? '',
      answer: map[fieldAnswer] as String? ?? '',
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
  final int errorLine;
  final String target;
  final String answer;
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
      fieldErrorLine: errorLine,
      fieldTarget: target,
      fieldAnswer: answer,
      fieldDifficulty: difficulty,
      fieldIsArchived: isArchived,
      fieldTags: tags,
    };
  }
}
