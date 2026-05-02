import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/error_detection_challenge.dart';
import '../models/loop_challenge.dart';

abstract class DatabaseService {
  Future<List<LoopChallenge>> fetchPuzzlesByType(String type);
  Future<List<LoopChallenge>> fetchLoopPuzzles();
  Future<List<ErrorDetectionChallenge>> fetchErrorDetectionPuzzles();
  Stream<List<LoopChallenge>> getLoopPuzzles();
}

class FirestoreDatabaseService implements DatabaseService {
  FirestoreDatabaseService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  static const _puzzlesCollection = 'puzzles';
  static const _loopScoutType = 'loop_scout';
  static const _errorDetectionType = 'error_detection';
  static const _fieldType = 'type';
  static const _fieldIsArchived = 'is_archived';

  Query<Map<String, dynamic>> _activePuzzlesByTypeQuery(String type) {
    final normalizedType = type.trim();
    if (normalizedType.isEmpty) {
      throw ArgumentError.value(type, 'type', 'Puzzle type cannot be empty.');
    }

    return _firestore
        .collection(_puzzlesCollection)
        .where(_fieldType, isEqualTo: normalizedType)
        .where(_fieldIsArchived, isEqualTo: false);
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
  Future<List<ErrorDetectionChallenge>> fetchErrorDetectionPuzzles() async {
    final snapshot = await _activePuzzlesByTypeQuery(_errorDetectionType).get();
    return snapshot.docs
        .map(ErrorDetectionChallenge.fromFirestore)
        .toList(growable: false);
  }

  @override
  Stream<List<LoopChallenge>> getLoopPuzzles() {
    return _activePuzzlesByTypeQuery(
      _loopScoutType,
    ).snapshots().map((snapshot) => _mapValidChallenges(snapshot.docs));
  }
}
