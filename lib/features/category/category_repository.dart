
import 'category_model.dart';

abstract class CategoryRepository {
  // Get all categories
  Future<List<MenuCategory>> getCategories();

  // Get active categories
  Future<List<MenuCategory>> getActiveCategories();

  // Get a single category
  Future<MenuCategory?> getCategory(String id);

  // Add category
  Future<void> addCategory(MenuCategory category);

  // Update category
  Future<void> updateCategory(MenuCategory category);

  // Delete category
  Future<void> deleteCategory(String id);
}