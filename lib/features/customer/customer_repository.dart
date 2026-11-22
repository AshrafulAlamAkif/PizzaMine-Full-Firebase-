
import 'customer_model.dart';

abstract class CustomerRepository {
  Future<void> createCustomer(Customer customer);

  Future<Customer?> getCustomer(String uid);
}