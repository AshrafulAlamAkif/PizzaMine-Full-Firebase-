
import 'package:cloud_firestore/cloud_firestore.dart';

import 'category_model.dart';
import 'category_repository.dart';

class FirebaseCategoryRepository
    implements CategoryRepository {
  final FirebaseFirestore _firestore;

  FirebaseCategoryRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _categories =>
      _firestore.collection('categories');

  @override
  Future<List<MenuCategory>> getCategories() async {
    final snapshot = await _categories
        .orderBy('sortOrder')
        .get();

    return snapshot.docs.map((doc) {
      return MenuCategory.fromMap(doc.id, doc.data());
    }).toList();
  }

  @override
  Future<List<MenuCategory>> getActiveCategories() async {
    final snapshot = await _categories
        .where('isActive', isEqualTo: true)
        .orderBy('sortOrder')
        .get();

    return snapshot.docs.map((doc) {
      return MenuCategory.fromMap(doc.id, doc.data());
    }).toList();
  }

  @override
  Future<MenuCategory?> getCategory(String id) async {
    final snapshot = await _categories.doc(id).get();

    if (!snapshot.exists) return null;

    return MenuCategory.fromMap(
      snapshot.id,
      snapshot.data()!,
    );
  }

  @override
  Future<void> addCategory(MenuCategory category) async {
    final docRef = category.id.isEmpty
        ? _categories.doc()
        : _categories.doc(category.id);

    await docRef.set({
      ...category.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateCategory(MenuCategory category) async {
    await _categories.doc(category.id).update({
      ...category.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _categories.doc(id).delete();
  }
}