import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wineasy/components/side_nav_bar.dart';

//import for the image
import 'package:image/image.dart' as img;
import 'dart:typed_data';

import 'package:wineasy/screens/products.dart';

class ProductDescription extends StatefulWidget {
  final String productName;
  final String productPrice;
  final String productType;
  final String productCategory;
  final String productDescription;
  final img.Image decodedImage;
  final String productId;
  final bool isProductAvailable;

  const ProductDescription(
      {super.key,
      required this.productName,
      required this.productPrice,
      required this.productType,
      required this.productCategory,
      required this.productDescription,
      required this.productId,
      required this.isProductAvailable,
      required this.decodedImage});

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  //state controller for delete
  bool isDeleting = false;
  @override
  Widget build(BuildContext context) {
    // Convert product price to an integer
    final int productPriceInt = int.parse(widget.productPrice);

    // Divide the product price by 100 and format with two decimal places
    final double formattedPriceDouble = productPriceInt / 100.0;

    // Format the double with two decimal places
    final formattedPrice = '₹ ${formattedPriceDouble.toStringAsFixed(2)}';

    Color imageColor =
        widget.isProductAvailable ? Colors.transparent : Colors.black;

    return Scaffold(
      drawer: const SideNavBar(),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              // Navigator.pop(context);

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Products()));
            },
            icon: const Icon(Icons.arrow_back)),
        backgroundColor: Colors.transparent,
      ),
      body: Row(
        children: [
          Container(
            width: 450,
            decoration: BoxDecoration(
                border: const Border(
                    right: BorderSide(width: 3, color: Colors.black)),
                color: Colors.grey.shade200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //1st widget in column
                SizedBox(
                    height: 169,
                    width: 320,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        imageColor,
                        BlendMode.color,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          Uint8List.fromList(
                              img.encodePng(widget.decodedImage)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),

                //2nd widget in column
                const SizedBox(
                  height: 15,
                ),

                //3rd widget in column
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 60.0),
                    child: Text(
                      widget.productName,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),

                //4th widget in column
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.productDescription,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

                //5th widget in column
                const SizedBox(
                  height: 15,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedPrice,
                        style: TextStyle(
                            color: Colors.green.shade500,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                          onPressed: handleDeleteClick,
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Color.fromARGB(255, 241, 37, 37),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
          const Center(
            child: Text('data'),
          )
        ],
      ),
    );
  }

  void handleDeleteClick() {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              alignment: Alignment.center,
              title: const Align(
                  alignment: Alignment.center,
                  child: Text('Are you sure want to delete?')),
              children: [
                //1st child
                const SizedBox(
                  height: 35,
                ),

                //2nd child
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //1st Widget in Row

                      TextButton(
                          onPressed: deleteProduct,
                          child: const Text('Confirm')),

                      //2nd Widget in Row
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                    ],
                  ),
                )
              ],
            ));
  }

  void deleteProduct() async {
    isDeleting = true;

    //API endpoint
    const String deleteProductsUrl = "http://localhost:4848/api/delete-product";

    //enconding the product Id
    String encodedString = base64Encode(utf8.encode(widget.productId));

    try {
      Response serverResponse =
          await Dio().delete(deleteProductsUrl, queryParameters: {
        'productId': encodedString,
      });

      if (serverResponse.statusCode == 200) {
        if (context.mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Products()));
        }
      }
    } catch (error) {
      print('unexpected server error at product description: $error');
    } finally {
      setState(() {
        isDeleting = false;
      });
    }
  }
}
