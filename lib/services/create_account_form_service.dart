import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class CreateAccountFormService {
  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final RegExp _passwordLetterPattern = RegExp(r'[A-Za-z]');
  static final RegExp _passwordDigitPattern = RegExp(r'\d');

  const CreateAccountFormService();

  String? validateCredentials({
    required String email,
    required String password,
    required String confirmedPassword,
  }) {
    if (email.isEmpty) {
      return 'Please enter an email address.';
    }
    if (!_emailPattern.hasMatch(email)) {
      return 'Please enter a valid email address.';
    }
    if (password.isEmpty) {
      return 'Please enter a password.';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    if (!_passwordLetterPattern.hasMatch(password) ||
        !_passwordDigitPattern.hasMatch(password)) {
      return 'Password must include at least one letter and one number.';
    }
    if (confirmedPassword.isEmpty) {
      return 'Please verify your password.';
    }
    if (password != confirmedPassword) {
      return 'Password verification does not match.';
    }
    return null;
  }

  String buildAuthErrorMessage(Object error) {
    if (error is TimeoutException) {
      return 'Authentication timed out. Check your internet connection and try again.';
    }
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'operation-not-allowed':
          return 'Email/password sign-in is not enabled in Firebase Console.';
        case 'email-already-in-use':
          return 'That email is already in use. Try signing in instead.';
        case 'invalid-email':
          return 'Firebase rejected this email address as invalid.';
        case 'weak-password':
          return 'Firebase rejected this password as too weak.';
        case 'network-request-failed':
          return 'Network request failed while contacting Firebase.';
        default:
          return 'Authentication failed (${error.code}): ${error.message ?? 'Unknown error'}';
      }
    }

    return 'Authentication failed: $error';
  }
}
