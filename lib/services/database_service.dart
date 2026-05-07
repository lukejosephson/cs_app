import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/error_detection_challenge.dart';
import '../models/loop_challenge.dart';
import '../models/operations_practice_challenge.dart';
import '../models/user_progress.dart';

abstract class DatabaseService {
  Future<List<LoopChallenge>> fetchPuzzlesByType(String type);
  Future<List<LoopChallenge>> fetchLoopPuzzles();
  Future<List<ErrorDetectionChallenge>> fetchErrorDetectionPuzzles();
  Future<List<OperationsPracticeChallenge>> fetchOperationsPuzzles();
  Future<UserProgress> getUserProgress(String uid);
  Future<void> updateUserProgress(UserProgress progress);
  Stream<List<LoopChallenge>> getLoopPuzzles();
}

class FirestoreDatabaseService implements DatabaseService {
  FirestoreDatabaseService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  static const _puzzlesCollection = 'puzzles';
  static const _loopScoutType = 'loop_scout';
  static const _errorDetectionType = 'error_detection';
  static const _operationsPracticeType = 'operations_practice';
  static const _usersCollection = 'users';
  static const _fieldType = 'type';
  static const _fieldIsArchived = 'is_archived';

  Query<Map<String, dynamic>> _puzzlesByTypeQuery(String type) {
    final normalizedType = type.trim();
    if (normalizedType.isEmpty) {
      throw ArgumentError.value(type, 'type', 'Puzzle type cannot be empty.');
    }

    return _firestore
        .collection(_puzzlesCollection)
        .where(_fieldType, isEqualTo: normalizedType);
  }

  Query<Map<String, dynamic>> _activePuzzlesByTypeQuery(String type) {
    return _puzzlesByTypeQuery(type).where(_fieldIsArchived, isEqualTo: false);
  }

  List<LoopChallenge> _mapValidChallenges(
    Iterable<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    return docs
        .map(LoopChallenge.fromFirestore)
        .where((challenge) => challenge.hasRequiredPromptFields)
        .toList(growable: false);
  }

  List<ErrorDetectionChallenge> _mapValidErrorDetectionChallenges(
    Iterable<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    return docs
        .map(ErrorDetectionChallenge.fromFirestore)
        .where((challenge) => challenge.hasRequiredPromptFields)
        .toList(growable: false);
  }

  List<OperationsPracticeChallenge> _mapValidOperationsChallenges(
    Iterable<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    return docs
        .map(OperationsPracticeChallenge.fromFirestore)
        .where((challenge) => challenge.hasRequiredPromptFields)
        .toList(growable: false);
  }

  @override
  Future<List<LoopChallenge>> fetchPuzzlesByType(String type) async {
    final snapshot = await _puzzlesByTypeQuery(type).get();

    return _mapValidChallenges(snapshot.docs);
  }

  @override
  Future<List<LoopChallenge>> fetchLoopPuzzles() async {
    final snapshot = await _activePuzzlesByTypeQuery(_loopScoutType).get();
    return _mapValidChallenges(snapshot.docs);
  }

  @override
  Future<List<ErrorDetectionChallenge>> fetchErrorDetectionPuzzles() async {
    final snapshot = await _activePuzzlesByTypeQuery(_errorDetectionType).get();
    return _mapValidErrorDetectionChallenges(snapshot.docs);
  }

  @override
  Future<List<OperationsPracticeChallenge>> fetchOperationsPuzzles() async {
    final snapshot = await _activePuzzlesByTypeQuery(
      _operationsPracticeType,
    ).get();
    return _mapValidOperationsChallenges(snapshot.docs);
  }

  @override
  Future<UserProgress> getUserProgress(String uid) async {
    final normalizedUid = uid.trim();
    if (normalizedUid.isEmpty) {
      throw ArgumentError.value(uid, 'uid', 'User ID cannot be empty.');
    }

    final snapshot = await _firestore
        .collection(_usersCollection)
        .doc(normalizedUid)
        .get();
    if (!snapshot.exists) {
      return UserProgress.empty(normalizedUid);
    }

    return UserProgress.fromFirestore(snapshot);
  }

  @override
  Future<void> updateUserProgress(UserProgress progress) async {
    await _firestore
        .collection(_usersCollection)
        .doc(progress.userId)
        .set(progress.toMap(), SetOptions(merge: true));
  }

  @override
  Stream<List<LoopChallenge>> getLoopPuzzles() {
    return _activePuzzlesByTypeQuery(
      _loopScoutType,
    ).snapshots().map((snapshot) => _mapValidChallenges(snapshot.docs));
  }
}
