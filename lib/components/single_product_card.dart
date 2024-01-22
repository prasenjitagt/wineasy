import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

//import for the image
import 'package:image/image.dart' as img;
import 'dart:convert';
import 'dart:typed_data';

import 'package:wineasy/screens/product_description.dart';

class SingleProductCard extends StatefulWidget {
  final String productName;
  final String productPrice;
  final String productType;
  final String productCategory;
  final String productDescription;
  final String imageFile;
  final String productId;
  final bool isAvailable;

  const SingleProductCard(
      {super.key,
      required this.productName,
      required this.productPrice,
      required this.productType,
      required this.productCategory,
      required this.productDescription,
      required this.imageFile,
      required this.productId,
      required this.isAvailable});

  @override
  State<SingleProductCard> createState() => _SingleProductCardState();
}

class _SingleProductCardState extends State<SingleProductCard> {
  bool isProductAvailable = false;

  @override
  void initState() {
    super.initState();
    isProductAvailable = widget.isAvailable;
  }

  @override
  Widget build(BuildContext context) {
    Color imageColor = isProductAvailable ? Colors.transparent : Colors.black;

//Getting the Product Image from base64 String
    img.Image? decodedImage = base64StringToImage(widget.imageFile);

    // Convert product price to an integer
    final int productPriceInt = int.parse(widget.productPrice);

    // Divide the product price by 100 and format with two decimal places
    final double formattedPriceDouble = productPriceInt / 100.0;

    // Format the double with two decimal places
    final formattedPrice = '₹ ${formattedPriceDouble.toStringAsFixed(2)}';
    return Container(
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
                    Uint8List.fromList(img.encodePng(decodedImage!)),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //1st widget in row
                  SizedBox(
                    width: 180,
                    child: Text(
                      widget.productName,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),

                  //2nd widget in row Switch
                  Transform.scale(
                      scale: 0.5,
                      child: Switch(
                          activeColor: Colors.green.shade600,
                          value: isProductAvailable,
                          onChanged: updateIsAvailable))
                ],
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
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                    onPressed: handleEditClick,
                    icon: const Icon(
                      Icons.edit_document,
                      color: Color.fromARGB(255, 241, 37, 37),
                    )),
              )
            ],
          )
        ],
      ),
    );
  }

  void updateIsAvailable(bool value) async {
    try {
      setState(() {
        isProductAvailable = value;
      });

      String encodedString = base64Encode(utf8.encode(widget.productId));
      const String isAvailableUrl = "http://localhost:4848/api/is-available";
      Response serverResponse =
          await Dio().put(isAvailableUrl, queryParameters: {
        'productId': encodedString,
        'isAvailableFromFrontend': isProductAvailable,
      });
      print(serverResponse);
    } catch (e) {
      print('Error fetching data: $e');
      rethrow;
    }
  }

  //Fucntion for clicking the edit icon
  void handleEditClick() {
    img.Image? decodedImage = base64StringToImage(widget.imageFile);

    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => ProductDescription(
    //             productName: widget.productName,
    //             productPrice: widget.productPrice,
    //             productType: widget.productType,
    //             productCategory: widget.productCategory,
    //             productDescription: widget.productDescription,
    //             decodedImage: decodedImage as img.Image,
    //             productId: widget.productId,
    //             isProductAvailable: isProductAvailable)));

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProductDescription(
                productName: widget.productName,
                productPrice: widget.productPrice,
                productType: widget.productType,
                productCategory: widget.productCategory,
                productDescription: widget.productDescription,
                decodedImage: decodedImage as img.Image,
                productId: widget.productId,
                isProductAvailable: isProductAvailable)));
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
