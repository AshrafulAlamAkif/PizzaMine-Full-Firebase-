// Step 6 — Riverpod Providers
// এখন অন্য কোনো feature থেকে authentication প্রয়োজন হলে শুধু authRepositoryProvider ব্যবহার করব।
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/device/device_service.dart';

import 'auth_model.dart';
import 'auth_repository.dart';
import 'firebase_auth_repository.dart';
import 'auth_service.dart';

import '../customer/customer_provider.dart';

// Authentication Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});

// Device Service
final deviceServiceProvider = Provider<DeviceService>((ref) {
  return DeviceService();
});

// Authentication Service
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    authRepository: ref.watch(authRepositoryProvider),
    customerRepository: ref.watch(customerRepositoryProvider),
    deviceService: ref.watch(deviceServiceProvider),
  );
});

// Authentication State
final authStateProvider = StreamProvider<AppUser?>((ref) {
  final repository = ref.watch(authRepositoryProvider);

  return repository.authStateChanges;
});