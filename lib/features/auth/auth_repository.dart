// Step 4 — Authentication Repository
import 'auth_model.dart';

abstract class AuthRepository {
  Stream<AppUser?> get authStateChanges;

  Future<AppUser> signIn({
    required String email,
    required String password,
  });

  Future<AppUser> signUp({
    required String email,
    required String password,
    required String displayName,
  });

  Future<void> resetPassword(String email);
  // Email Verification করতে নিচের দুটি নতুন method
  Future<void> sendEmailVerification();
  Future<bool> reloadCurrentUser();

  Future<void> signOut();
}