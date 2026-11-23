
import 'package:cloud_firestore/cloud_firestore.dart';

import 'customer_model.dart';
import 'customer_repository.dart';

class FirebaseCustomerRepository
    implements CustomerRepository {
  final FirebaseFirestore _firestore;

  FirebaseCustomerRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _customers =>
      _firestore.collection('customers');

  @override
  Future<void> createCustomer(Customer customer) async {
    await _customers.doc(customer.uid).set({
      ...customer.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<Customer?> getCustomer(String uid) async {
    final snapshot = await _customers.doc(uid).get();

    if (!snapshot.exists) return null;

    return Customer.fromMap(snapshot.data()!);
  }

  @override
  Future<void> updateCustomer({
    required String uid,
    required String fullName,
    required String phoneNumber,
  }) async {
    await _customers.doc(uid).update({
      'fullName': fullName.trim(),
      'phoneNumber': phoneNumber.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}