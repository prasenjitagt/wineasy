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
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Products()));
            },
            icon: const Icon(Icons.arrow_back)),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
          child: Container(
        decoration: BoxDecoration(
            // border: Border.all(width: 2, color: Colors.black),
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade200),
        child: Column(
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
                      Uint8List.fromList(img.encodePng(widget.decodedImage)),
                      fit: BoxFit.cover,
                    ),
                  ),
                )),

            //2nd widget in column
            const SizedBox(
              height: 15,
            ),

            //3rd widget in column
            Padding(
              padding: const EdgeInsets.only(left: 35.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 35.0),
                  child: Text(
                    formattedPrice,
                    style: TextStyle(
                        color: Colors.green.shade500,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}