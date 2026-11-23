// এখানে FutureProvider ব্যবহার করেছি কারণ Customer Profile একবার fetch করলেই আপাতত যথেষ্ট। প্রতিটি screen rebuild-এ নতুন করে database request হবে না।

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_provider.dart';
import 'customer_model.dart';
import 'customer_repository.dart';
import 'firebase_customer_repository.dart';

final customerRepositoryProvider =
    Provider<CustomerRepository>((ref) {
  return FirebaseCustomerRepository();
});

final customerProfileProvider =
    FutureProvider<Customer?>((ref) async {
  // Authentication State পর্যবেক্ষণ করা হচ্ছে
  final authState = ref.watch(authStateProvider);

  final user = authState.when(
    // Authenticated: User Login করা থাকলে User Data পাওয়া যাবে
    data: (user) => user,
    // Loading: Authentication State এখনো Check হচ্ছে
    loading: () => null,
    // Error: Authentication Check করতে কোনো সমস্যা হলে Error Throw হবে
    error: (error, stackTrace) => throw error,
  );

  if (user == null) {
    // Loading: Authentication এখনো Complete না হলে অপেক্ষা করবে
    if (authState.isLoading) {
      await ref.watch(authStateProvider.future);
    }

    // Unauthenticated: কোনো User Login করা না থাকলে null Return করবে
    return null;
  }

  // Authenticated: Login করা User-এর Customer Repository Access করা হচ্ছে
  final repository = ref.watch(customerRepositoryProvider);

  // Firebase UID অনুযায়ী Customer Profile Fetch করা হচ্ছে
  return repository.getCustomer(user.id);
});