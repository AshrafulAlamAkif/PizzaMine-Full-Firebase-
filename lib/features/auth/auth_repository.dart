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

  Future<void> signOut();
}