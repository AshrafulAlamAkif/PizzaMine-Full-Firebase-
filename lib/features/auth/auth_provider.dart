// Step 6 — Riverpod Providers
// এখন অন্য কোনো feature থেকে authentication প্রয়োজন হলে শুধু authRepositoryProvider ব্যবহার করব।
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_model.dart';
import 'auth_repository.dart';
import 'firebase_auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});

final authStateProvider = StreamProvider<AppUser?>((ref) {
  final repository = ref.watch(authRepositoryProvider);

  return repository.authStateChanges;
});