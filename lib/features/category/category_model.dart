
class MenuCategory {
  final String id;
  final String name;
  final String imageUrl;
  final bool isActive;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MenuCategory({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.isActive,
    required this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'sortOrder': sortOrder,
    };
  }

  factory MenuCategory.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return MenuCategory(
      id: id,
      name: map['name'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      isActive: map['isActive'] as bool? ?? true,
      sortOrder: (map['sortOrder'] as num?)?.toInt() ?? 0,
      createdAt: map['createdAt']?.toDate(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }
}