// product_model.dart
class ProductModel {
  final String productName;
  final String price;
  final String typeOfProduct;
  final String categoryOfProduct;
  final String description;
  final String imageFile;
  final String productId;
  final bool isAvailable;

  ProductModel({
    required this.isAvailable,
    required this.productId,
    required this.imageFile,
    required this.productName,
    required this.price,
    required this.typeOfProduct,
    required this.categoryOfProduct,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productName: json['productName'] ?? '',
      price: json['price'].toString(),
      typeOfProduct: json['typeOfProduct'] ?? '',
      categoryOfProduct: json['categoryOfProduct'] ?? '',
      description: json['description'] ?? '',
      imageFile: json['image'] ?? '',
      productId: json['_id'] ?? 'no_id',
      isAvailable: json['isAvailable'] ?? true,
    );
  }
}
