
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'category_model.dart';
import 'category_repository.dart';
import 'firebase_category_repository.dart';

// Category Repository Provider
final categoryRepositoryProvider =
    Provider<CategoryRepository>((ref) {
  return FirebaseCategoryRepository();
});

// All Categories Provider
final categoriesProvider =
    FutureProvider<List<MenuCategory>>((ref) async {
  final repository = ref.watch(categoryRepositoryProvider);

  return repository.getCategories();
});

// Active Categories Provider
final activeCategoriesProvider =
    FutureProvider<List<MenuCategory>>((ref) async {
  final repository = ref.watch(categoryRepositoryProvider);

  return repository.getActiveCategories();
});

// Single Category Provider
final categoryProvider =
    FutureProvider.family<MenuCategory?, String>(
  (ref, id) async {
    final repository = ref.watch(categoryRepositoryProvider);

    return repository.getCategory(id);
  },
);