import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StreamProvider<bool>((ref) {
  return ref.watch(authServiceProvider).authStateChanges();
});

final authActionStateProvider = StateProvider<AsyncValue<void>>((ref) {
  return const AsyncData(null);
});

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

class AuthController {
  const AuthController(this._ref);

  final Ref _ref;

  AuthService get _authService => _ref.read(authServiceProvider);
  StateController<AsyncValue<void>> get _actionStateController =>
      _ref.read(authActionStateProvider.notifier);

  Future<void> signInAnonymously() async {
    _actionStateController.state = const AsyncLoading();
    _actionStateController.state = await AsyncValue.guard(
      _authService.signInAnonymously,
    );
  }

  Future<void> signInWithGoogle() async {
    _actionStateController.state = const AsyncLoading();
    _actionStateController.state = await AsyncValue.guard(
      _authService.signInWithGoogle,
    );
  }

  Future<void> signOut() {
    return _authService.signOut();
  }
}
