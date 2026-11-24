
import 'package:cloud_firestore/cloud_firestore.dart';

import 'menu_model.dart';
import 'menu_repository.dart';

class FirebaseMenuRepository implements MenuRepository {
  final FirebaseFirestore _firestore;

  FirebaseMenuRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection('products');

  @override
  Future<void> addProduct(MenuProduct product) async {
    final docRef = product.id.isEmpty
        ? _products.doc()
        : _products.doc(product.id);

    await docRef.set({
      ...product.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<MenuProduct?> getProduct(String id) async {
    final snapshot = await _products.doc(id).get();

    if (!snapshot.exists) return null;

    return MenuProduct.fromMap(
      snapshot.id,
      snapshot.data()!,
    );
  }

  @override
  Future<List<MenuProduct>> getProducts() async {
    final snapshot = await _products
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return MenuProduct.fromMap(doc.id, doc.data());
    }).toList();
  }

  @override
  Future<void> updateProduct(MenuProduct product) async {
    await _products.doc(product.id).update({
      ...product.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _products.doc(id).delete();
  }

  @override
  Future<List<MenuProduct>> getAvailableProducts() async {
    final snapshot = await _products
        .where('isAvailable', isEqualTo: true)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) {
      return MenuProduct.fromMap(doc.id, doc.data());
    }).toList();
  }

  @override
  Future<List<MenuProduct>> getProductsByCategory(
    String category,
  ) async {
    final snapshot = await _products
        .where('category', isEqualTo: category)
        .where('isAvailable', isEqualTo: true)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) {
      return MenuProduct.fromMap(doc.id, doc.data());
    }).toList();
  }
}