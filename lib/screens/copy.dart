// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wineasy/components/side_nav_bar.dart';
import 'package:wineasy/components/singleProductCard.dart';
import 'package:wineasy/models/product_model.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<ProductModel> productsList = [];

  @override
  void initState() {
    super.initState();
    fetchProductData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideNavBar(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
            itemCount: productsList.length,
            itemBuilder: (context, index) {
              return SingleProductCard(
                productName: productsList[index].productName,
                productPrice: productsList[index].price,
                productType: productsList[index].typeOfProduct,
                productCategory: productsList[index].categoryOfProduct,
                productDescription: productsList[index].description,
                imageFile: productsList[index].imageFile,
              );
            }),
      ),
    );
  }

  Future<void> fetchProductData() async {
    const String getProductsUrl = "http://localhost:4848/api/product-list";

    Response serverResponse = await Dio().get(
      getProductsUrl,

      //   onReceiveProgress: (int received, int total) {
      // double doublePercentage = ((received * 100) / total);
      // String finalPercentage = doublePercentage.toStringAsFixed(2);
      // print('$finalPercentage% done');}
    );

    setState(() {
      // Use cast to explicitly convert the List<dynamic> to List<Product>
      productsList = (serverResponse.data as List<dynamic>)
          .map((productData) => ProductModel.fromJson(productData))
          .toList();

      print(serverResponse.statusCode);
    });
    print(serverResponse.statusCode);
  }
}
