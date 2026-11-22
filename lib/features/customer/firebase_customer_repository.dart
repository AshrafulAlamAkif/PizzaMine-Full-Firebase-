
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
    });
  }

  @override
  Future<Customer?> getCustomer(String uid) async {
    final snapshot = await _customers.doc(uid).get();

    if (!snapshot.exists) return null;

    final data = snapshot.data()!;

    return Customer(
      uid: data['uid'] as String,
      fullName: data['fullName'] as String,
      email: data['email'] as String,
      phoneNumber: data['phoneNumber'] as String?,
      role: data['role'] as String,
      isActive: data['isActive'] as bool,
      installationId: data['installationId'] as String,
      platform: data['platform'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}