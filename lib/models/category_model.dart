// category_model.dart
class CategoryModel {
  final String categoryId;

  final String categoryOfFood;

  CategoryModel({
    required this.categoryOfFood,
    required this.categoryId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryOfFood: json['categoryName'] ?? '',
      categoryId: json['_id'] ?? 'no_id',
    );
  }
}
