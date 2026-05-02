import 'package:cloud_firestore/cloud_firestore.dart';

class ErrorDetectionChallenge {
  static const fieldDifficulty = 'difficulty';
  static const fieldErrorLine = 'error_line';
  static const fieldId = 'id';
  static const fieldIsArchived = 'is_archived';
  static const fieldSnippet = 'snippet';
  static const fieldTags = 'tags';
  static const fieldTarget = 'target';
  static const fieldType = 'type';

  const ErrorDetectionChallenge({
    required this.id,
    required this.type,
    required this.snippet,
    required this.errorLine,
    required this.target,
    required this.difficulty,
    required this.isArchived,
    required this.tags,
  });

  factory ErrorDetectionChallenge.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    final docIdAsInt = int.tryParse(snapshot.id);

    return ErrorDetectionChallenge.fromMap({
      ...data,
      fieldId: (data[fieldId] as num?)?.toInt() ?? docIdAsInt ?? 0,
    });
  }

  factory ErrorDetectionChallenge.fromMap(Map<String, dynamic> map) {
    return ErrorDetectionChallenge(
      id: (map[fieldId] as num?)?.toInt() ?? 0,
      type: map[fieldType] as String? ?? '',
      snippet: map[fieldSnippet] as String? ?? '',
      errorLine: (map[fieldErrorLine] as num?)?.toInt() ?? 0,
      target: map[fieldTarget] as String? ?? '',
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
  final int difficulty;
  final bool isArchived;
  final List<String> tags;

  Map<String, dynamic> toMap() {
    return {
      fieldId: id,
      fieldType: type,
      fieldSnippet: snippet,
      fieldErrorLine: errorLine,
      fieldTarget: target,
      fieldDifficulty: difficulty,
      fieldIsArchived: isArchived,
      fieldTags: tags,
    };
  }

  ErrorDetectionChallenge copyWith({
    int? id,
    String? type,
    String? snippet,
    int? errorLine,
    String? target,
    int? difficulty,
    bool? isArchived,
    List<String>? tags,
  }) {
    return ErrorDetectionChallenge(
      id: id ?? this.id,
      type: type ?? this.type,
      snippet: snippet ?? this.snippet,
      errorLine: errorLine ?? this.errorLine,
      target: target ?? this.target,
      difficulty: difficulty ?? this.difficulty,
      isArchived: isArchived ?? this.isArchived,
      tags: tags ?? this.tags,
    );
  }
}
