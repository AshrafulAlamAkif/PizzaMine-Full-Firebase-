// Step 10 — Navigation Update

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../features/splash/splash_screen.dart';
import '../features/auth/auth_screen.dart';
import '../features/auth/email_verification_screen.dart';
import '../features/home/home_screen.dart';
import '../features/customer/edit_profile_screen.dart';
import '../features/menu/menu_screen.dart';
import '../features/menu/product_details_screen.dart';

// Listen to Firebase authentication changes.
class AuthRefreshListenable extends ChangeNotifier {
  AuthRefreshListenable() {
    _subscription = FirebaseAuth.instance.userChanges().listen(
      (_) => notifyListeners(),
    );
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final _authRefreshListenable = AuthRefreshListenable();

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  refreshListenable: _authRefreshListenable,

  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final location = state.matchedLocation;

    final isLoggedIn = user != null;
    final isVerified = user?.emailVerified ?? false;

    final isProtectedRoute =
        location == '/home' ||
        location == '/edit-profile' ||
        location == '/menu' ||
        location.startsWith('/product/');

    // User must be logged in to access protected routes.
    if (isProtectedRoute && !isLoggedIn) {
      return '/login';
    }

    // Unverified users cannot access protected routes.
    if (isProtectedRoute && !isVerified) {
      return '/verify-email';
    }

    // Verification screen requires authentication.
    if (location == '/verify-email' && !isLoggedIn) {
      return '/login';
    }

    // Prevent authenticated users from returning to login/register.
    if (location == '/login' || location == '/register') {
      if (isLoggedIn) {
        return isVerified ? '/home' : '/verify-email';
      }
    }

    return null;
  },

  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(
      path: '/login',
      builder: (context, state) => const AuthScreen(),
    ),

    GoRoute(
      path: '/register',
      builder: (context, state) => const AuthScreen(
        isRegister: true,
      ),
    ),

    GoRoute(
      path: '/verify-email',
      builder: (context, state) =>
          const EmailVerificationScreen(),
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),

    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),

    GoRoute(
      path: '/menu',
      builder: (context, state) => const MenuScreen(),
    ),

    GoRoute(
      path: '/product/:productId',
      builder: (context, state) {
        final productId = state.pathParameters['productId']!;

        return ProductDetailsScreen(
          productId: productId,
        );
      },
    ),
  ],
);