// Step 9 — Home Screen
// Login সফল হলে আপাতত একটি simple Home Screen দেখাব।

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_provider.dart';
import '../customer/customer_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerState = ref.watch(customerProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pizzamine',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Edit Profile',
            onPressed: () async {
              final updated = await context.push<bool>(
                '/edit-profile',
              );

              if (updated == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated successfully!'),
                  ),
                );
              }
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              await ref
                  .read(authRepositoryProvider)
                  .signOut();

              if (context.mounted) {
                context.go('/login');
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: customerState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Unable to load customer profile.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(customerProfileProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (customer) {
          if (customer == null) {
            return const Center(
              child: Text(
                'Customer profile not found.',
              ),
            );
          }

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 90,
                    color: Color(0xFFE53935),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome to Pizzamine!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Customer Profile',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _profileItem(
                            Icons.person_outline,
                            'Full Name',
                            customer.fullName,
                          ),
                          _profileItem(
                            Icons.email_outlined,
                            'Email',
                            customer.email,
                          ),
                          _profileItem(
                            Icons.phone_outlined,
                            'Phone',
                            customer.phoneNumber ?? 'Not added',
                          ),
                          _profileItem(
                            Icons.verified_user_outlined,
                            'Account Status',
                            customer.isActive
                                ? 'Active'
                                : 'Inactive',
                          ),
                          _profileItem(
                            Icons.badge_outlined,
                            'Role',
                            customer.role,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _profileItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFE53935),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}