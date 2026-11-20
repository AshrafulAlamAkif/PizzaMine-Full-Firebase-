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
    String? displayName,
  });

  Future<void> signOut();
}