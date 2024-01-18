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
    Image productImage = base64StringToImage(imageFile);
    return Card(
      child: ListTile(
        leading: productImage,
        title: Text(productName),
      ),
    );
  }
}

Image base64StringToImage(String base64String) {
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
    return Image.memory(Uint8List.fromList(img.encodePng(decodedImage)));
  } else {
    // Return null or handle the error accordingly
    return Image.asset('assets/flutter-logo.png');
  }
}




/*
Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          decoration:
              BoxDecoration(color: Colors.orange.shade200, boxShadow: const [
            BoxShadow(color: Colors.grey, offset: Offset(0, 3), blurRadius: 8.0)
          ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name:$productName'),
                Divider(
                  thickness: 2,
                  color: Colors.orange.shade500,
                ),
                Text('Price:$productType'),
                Divider(
                  thickness: 2,
                  color: Colors.orange.shade500,
                ),
                Text('Name:$productCategory'),
                Divider(
                  thickness: 2,
                  color: Colors.orange.shade500,
                ),
                Text(
                  'Name:$productDescription',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    */