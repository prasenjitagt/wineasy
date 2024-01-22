// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wineasy/components/error_card.dart';
import 'package:wineasy/components/side_nav_bar.dart';
import 'package:wineasy/components/single_product_card.dart';
import 'package:wineasy/models/product_model.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  // initializing variable to get products from backend
  late Future<List<ProductModel>> futureProducts;

  @override
  void initState() {
    super.initState();

    //calling fetchProductData fucntion to store values that we got from backend
    futureProducts = fetchProductData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideNavBar(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder(
        //future builder for loading state
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading state
            return Center(
              child: CircularProgressIndicator(
                strokeAlign: CircularProgressIndicator.strokeAlignOutside,
                strokeWidth: 6,
                color: Colors.red.shade400,
              ),
            );
          } else if (snapshot.hasError) {
            // Error state
            return const Center(
              child: ErrorCard(errorText: "Failed to load data"),
            );
          } else {
            // Data loaded successfully
            List<ProductModel> productsList =
                snapshot.data as List<ProductModel>;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent:
                        320, // Set the number of columns in the grid
                    crossAxisSpacing: 15.0, // Set the spacing between columns
                    mainAxisSpacing: 15.0,
                    mainAxisExtent: 308 // Set the spacing between rows
                    ),
                itemCount: productsList.length,
                itemBuilder: (context, index) {
                  return SingleProductCard(
                    productName: productsList[index].productName,
                    productPrice: productsList[index].price,
                    productType: productsList[index].typeOfProduct,
                    productCategory: productsList[index].categoryOfProduct,
                    productDescription: productsList[index].description,
                    imageFile: productsList[index].imageFile,
                    productId: productsList[index].productId,
                    isAvailable: productsList[index].isAvailable,
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<ProductModel>> fetchProductData() async {
    const String getProductsUrl = "http://localhost:4848/api/product-list";

    try {
      Response serverResponse = await Dio().get(getProductsUrl);

      List<ProductModel> productsList = (serverResponse.data as List<dynamic>)
          .map((productData) => ProductModel.fromJson(productData))
          .toList();

      return productsList;
    } catch (e) {
      print('Error fetching data: $e');
      rethrow;
    }
  }
}
