import 'package:cs_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FakeAuthService implements AuthService {
  FakeAuthService({this.createAccountError});

  final Object? createAccountError;
  bool signOutCalled = false;
  var createAccountCallCount = 0;

  @override
  Stream<bool> authStateChanges() => const Stream<bool>.empty();

  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    createAccountCallCount++;
    if (createAccountError != null) {
      throw createAccountError!;
    }
    throw UnimplementedError('Success path is not used in these tests.');
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError('Not used in these tests.');
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    throw UnimplementedError('Not used in these tests.');
  }

  @override
  Future<void> signOut() async {
    signOutCalled = true;
  }
}
