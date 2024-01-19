import 'package:flutter/material.dart';

//for the image
import 'package:image/image.dart' as img;
import 'dart:convert';
import 'dart:typed_data';

class SingleProductCard extends StatelessWidget {
  final String productName;
  final String productPrice;
  final String productType;
  final String productCategory;
  final String productDescription;
  final String imageFile;
  const SingleProductCard(
      {super.key,
      required this.productName,
      required this.productPrice,
      required this.productType,
      required this.productCategory,
      required this.productDescription,
      required this.imageFile});

  @override
  Widget build(BuildContext context) {
//Getting the Product Image from base64 String
    img.Image? decodedImage = base64StringToImage(imageFile);

    // Convert product price to an integer
    final int productPriceInt = int.parse(productPrice);

    // Divide the product price by 100 and format with two decimal places
    final double formattedPriceDouble = productPriceInt / 100.0;

    // Format the double with two decimal places
    final formattedPrice = '₹ ${formattedPriceDouble.toStringAsFixed(2)}';
    return Container(
      decoration: BoxDecoration(
          // border: Border.all(width: 2, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade200),
      child: SingleChildScrollView(
        child: Column(
          children: [
            //1st widget in column
            SizedBox(
                height: 169,
                width: 320,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    Uint8List.fromList(img.encodePng(decodedImage!)),
                    fit: BoxFit.cover,
                  ),
                )),

            //2nd widget in column
            const SizedBox(
              height: 15,
            ),

            //3rd widget in column
            Padding(
              padding: const EdgeInsets.only(left: 35.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  productName,
                  maxLines: 1,
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
                  productDescription,
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
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Color.fromARGB(255, 241, 37, 37),
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

//Fuction for converting base64 to Image

img.Image? base64StringToImage(String base64String) {
  // Remove data:image/...;base64, prefix if it exists
  if (base64String.startsWith('data:image')) {
    base64String = base64String.split(',')[1];
  }

  // Decode the base64 string
  List<int> bytes = base64.decode(base64String);

  // Create an Image from the decoded bytes
  img.Image? decodedImage = img.decodeImage(Uint8List.fromList(bytes));

  // Check if decoding was successful
  if (decodedImage != null) {
    // Convert the Image to a Flutter Image widget
    return decodedImage;
  } else {
    // Return null or handle the error accordingly
    return null;
  }
}
