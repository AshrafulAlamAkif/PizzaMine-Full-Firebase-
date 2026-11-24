// Step 5 — Firebase Authentication Implementation
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/exceptions.dart';
import 'auth_model.dart';
import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  AppUser _mapUser(User user) {
    return AppUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }

  AppException _handleError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return const AppException(
          'Please enter a valid email address.',
        );

      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return const AppException(
          'Incorrect email or password.',
        );

      case 'email-already-in-use':
        return const AppException(
          'This email is already registered.',
        );

      case 'weak-password':
        return const AppException(
          'Please choose a stronger password.',
        );

      case 'network-request-failed':
        return const AppException(
          'Network error. Please try again.',
        );

      case 'too-many-requests':
        return const AppException(
          'Too many attempts. Try again later.',
        );

      default:
        return const AppException(
          'Something went wrong. Please try again.',
        );
    }
  }

  @override
  Stream<AppUser?> get authStateChanges {
    return _firebaseAuth.userChanges().map(
      (user) => user == null ? null : _mapUser(user),
    );
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return _mapUser(credential.user!);
    } on FirebaseAuthException catch (error) {
      throw _handleError(error);
    }
  }

  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user!;

      await user.updateDisplayName(displayName.trim());
      await user.reload();

      return _mapUser(_firebaseAuth.currentUser!);
    } on FirebaseAuthException catch (error) {
      throw _handleError(error);
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        throw const AppException(
          'Please sign in first.',
        );
      }

      if (user.emailVerified) return;

      await user.sendEmailVerification();
    } on FirebaseAuthException catch (error) {
      if (error.code == 'too-many-requests') {
        throw const AppException(
          'Verification email requests are temporarily limited. Please wait and try again later.',
        );
      }
      throw _handleError(error);
    }
  }

  @override
  Future<bool> reloadCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) return false;

      await user.reload();

      return _firebaseAuth.currentUser?.emailVerified ?? false;
    } on FirebaseAuthException catch (error) {
      throw _handleError(error);
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
        email: email.trim(),
      );
    } on FirebaseAuthException catch (error) {
      throw _handleError(error);
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}