// Step 7 — Splash Screen
// এখানে Firebase-এর login session check হবে। User already logged in থাকলে Home, অন্যথায় Login Screen দেখাবে।

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateProvider, (previous, next) async {
      if (!next.hasValue) return;

      final user = next.requireValue;

      if (!context.mounted) return;

      if (user == null) {
        context.go('/login');
        return;
      }

      try {
        final isVerified = await ref
            .read(authServiceProvider)
            .checkEmailVerification();

        if (!context.mounted) return;

        if (isVerified) {
          context.go('/home');
        } else {
          context.go('/verify-email');
        }
      } catch (_) {
        if (!context.mounted) return;

        context.go('/verify-email');
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFE53935),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.local_pizza_rounded,
              color: Colors.white,
              size: 90,
            ),
            const SizedBox(height: 16),
            const Text(
              'Pizzamine',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'A little slice of happiness.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),
            const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}