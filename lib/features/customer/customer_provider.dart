
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'customer_repository.dart';
import 'firebase_customer_repository.dart';

final customerRepositoryProvider =
    Provider<CustomerRepository>((ref) {
  return FirebaseCustomerRepository();
});