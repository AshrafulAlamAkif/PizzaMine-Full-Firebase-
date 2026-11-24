
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'menu_model.dart';
import 'menu_repository.dart';
import 'firebase_menu_repository.dart';

// Menu Repository Provider. Repository নির্বাচন
final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  return FirebaseMenuRepository();
});

// All Products Provider. সব Product
final menuProductsProvider =
    FutureProvider<List<MenuProduct>>((ref) async {
  final repository = ref.watch(menuRepositoryProvider);

  return repository.getProducts();
});

// Available Products Provider. Available Product
final availableProductsProvider =
    FutureProvider<List<MenuProduct>>((ref) async {
  final repository = ref.watch(menuRepositoryProvider);

  return repository.getAvailableProducts();
});

// Single Product Provider. নির্দিষ্ট Product
final menuProductProvider =
    FutureProvider.family<MenuProduct?, String>((ref, id) async {
  final repository = ref.watch(menuRepositoryProvider);

  return repository.getProduct(id);
});

// Products By Category Provider. Category অনুযায়ী Product
final productsByCategoryProvider =
    FutureProvider.family<List<MenuProduct>, String>(
  (ref, category) async {
    final repository = ref.watch(menuRepositoryProvider);

    return repository.getProductsByCategory(category);
  },
);