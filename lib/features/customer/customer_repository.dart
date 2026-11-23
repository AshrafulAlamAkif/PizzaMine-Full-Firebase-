
import 'customer_model.dart';

abstract class CustomerRepository {
  Future<void> createCustomer(Customer customer);

  Future<Customer?> getCustomer(String uid);

  //এখানে updateCustomer() নতুন method।
  Future<void> updateCustomer({
    required String uid,
    required String fullName,
    required String phoneNumber,
  });
}