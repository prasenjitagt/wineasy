// product_model.dart

class ProductModel {
  final String productName;
  final String price;
  final String typeOfProduct;
  final String categoryOfProduct;
  final String description;

  ProductModel({
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
    );
  }
}
