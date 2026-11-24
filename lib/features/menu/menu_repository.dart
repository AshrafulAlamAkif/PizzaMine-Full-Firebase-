
import 'menu_model.dart';

abstract class MenuRepository {
  // Add new product
  Future<void> addProduct(MenuProduct product);

  // Get a single product
  Future<MenuProduct?> getProduct(String id);

  // Get all products
  Future<List<MenuProduct>> getProducts();

  // Update product
  Future<void> updateProduct(MenuProduct product);

  // Delete product
  Future<void> deleteProduct(String id);

  // Get available products
  Future<List<MenuProduct>> getAvailableProducts();

  // Get products by category
  Future<List<MenuProduct>> getProductsByCategory(
    String category,
  );
}