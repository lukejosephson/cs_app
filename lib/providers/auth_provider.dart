import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return FirebaseAuthService();
});

final authStateProvider = StreamProvider<bool>((ref) {
  return ref.watch(authServiceProvider).authStateChanges();
});

final authActionStateProvider = StateProvider<AsyncValue<Object?>>((ref) {
  return const AsyncData(null);
});

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

class AuthController {
  const AuthController(this._ref);

  final Ref _ref;

  AuthService get _authService => _ref.read(authServiceProvider);
  StateController<AsyncValue<Object?>> get _actionStateController =>
      _ref.read(authActionStateProvider.notifier);

  Future<void> signInWithGoogle() async {
    _actionStateController.state = const AsyncLoading();
    final result = await AsyncValue.guard(_authService.signInWithGoogle);
    _actionStateController.state = result;
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _actionStateController.state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
    _actionStateController.state = result;
  }

  Future<bool> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _actionStateController.state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
    _actionStateController.state = result;
    return !result.hasError;
  }

  Future<void> signOut() {
    return _authService.signOut();
  }
}
