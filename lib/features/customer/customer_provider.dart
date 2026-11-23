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
  final authState = ref.watch(authStateProvider);

  if (!authState.hasValue) {
    return null;
  }

  final user = authState.requireValue;

  if (user == null) {
    return null;
  }

  final repository = ref.watch(customerRepositoryProvider);

  return repository.getCustomer(user.id);
});