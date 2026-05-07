import 'package:cloud_firestore/cloud_firestore.dart';

class UserProgress {
  static const fieldUserId = 'userId';
  static const fieldCompletedPuzzles = 'completedPuzzles';
  static const fieldFailedPuzzles = 'failedPuzzles';

  const UserProgress({
    required this.userId,
    required this.completedPuzzles,
    required this.failedPuzzles,
  });

  factory UserProgress.empty(String userId) {
    return UserProgress(
      userId: userId,
      completedPuzzles: const [],
      failedPuzzles: const [],
    );
  }

  factory UserProgress.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return UserProgress.fromMap({
      ...data,
      fieldUserId: (data[fieldUserId] as String?) ?? snapshot.id,
    });
  }

  factory UserProgress.fromMap(Map<String, dynamic> map) {
    return UserProgress(
      userId: map[fieldUserId] as String? ?? '',
      completedPuzzles: (map[fieldCompletedPuzzles] as List<dynamic>? ?? const [])
          .whereType<num>()
          .map((value) => value.toInt())
          .toList(growable: false),
      failedPuzzles: (map[fieldFailedPuzzles] as List<dynamic>? ?? const [])
          .whereType<num>()
          .map((value) => value.toInt())
          .toList(growable: false),
    );
  }

  final String userId;
  final List<int> completedPuzzles;
  final List<int> failedPuzzles;

  Map<String, dynamic> toMap() {
    return {
      fieldUserId: userId,
      fieldCompletedPuzzles: completedPuzzles,
      fieldFailedPuzzles: failedPuzzles,
    };
  }
}
