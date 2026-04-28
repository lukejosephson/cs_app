import 'package:cs_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FakeAuthService implements AuthService {
  FakeAuthService({this.createAccountError, this.createAccountSucceeds = false});

  final Object? createAccountError;
  final bool createAccountSucceeds;
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
    if (createAccountSucceeds) {
      return const _FakeUserCredential();
    }
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

class _FakeUserCredential implements UserCredential {
  const _FakeUserCredential();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
