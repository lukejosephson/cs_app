import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/loop_challenge.dart';

abstract class DatabaseService {
  Future<List<LoopChallenge>> fetchPuzzlesByType(String type);
  Future<List<LoopChallenge>> fetchLoopPuzzles();
  Stream<List<LoopChallenge>> getLoopPuzzles();
}

class FirestoreDatabaseService implements DatabaseService {
  FirestoreDatabaseService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  static const _puzzlesCollection = 'puzzles';
  static const _loopScoutType = 'loop_scout';

  Query<Map<String, dynamic>> _activePuzzlesByTypeQuery(String type) {
    final normalizedType = type.trim();
    if (normalizedType.isEmpty) {
      throw ArgumentError.value(type, 'type', 'Puzzle type cannot be empty.');
    }

    return _firestore
        .collection(_puzzlesCollection)
        .where(LoopChallenge.fieldType, isEqualTo: normalizedType)
        .where(LoopChallenge.fieldIsArchived, isEqualTo: false);
  }

  List<LoopChallenge> _mapValidChallenges(
    Iterable<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    return docs
        .map(LoopChallenge.fromFirestore)
        .where((challenge) => challenge.hasRequiredPromptFields)
        .toList(growable: false);
  }

  @override
  Future<List<LoopChallenge>> fetchPuzzlesByType(String type) async {
    final snapshot = await _activePuzzlesByTypeQuery(type).get();

    return _mapValidChallenges(snapshot.docs);
  }

  @override
  Future<List<LoopChallenge>> fetchLoopPuzzles() {
    return fetchPuzzlesByType(_loopScoutType);
  }

  @override
  Stream<List<LoopChallenge>> getLoopPuzzles() {
    return _activePuzzlesByTypeQuery(
      _loopScoutType,
    ).snapshots().map((snapshot) => _mapValidChallenges(snapshot.docs));
  }
}
