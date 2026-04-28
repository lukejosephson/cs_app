import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/loop_challenge.dart';

abstract class DatabaseService {
  Future<List<LoopChallenge>> fetchPuzzlesByType(String type);
}

class FirestoreDatabaseService implements DatabaseService {
  FirestoreDatabaseService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<List<LoopChallenge>> fetchPuzzlesByType(String type) async {
    final snapshot = await _firestore
        .collection('puzzles')
        .where(LoopChallenge.fieldType, isEqualTo: type)
        .get();

    return snapshot.docs.map(LoopChallenge.fromFirestore).toList(growable: false);
  }
}
