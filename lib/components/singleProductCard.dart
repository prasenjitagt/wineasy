import 'package:flutter/material.dart';

class SingleProductCard extends StatelessWidget {
  final String productName;
  final String productPrice;
  final String productType;
  final String productCategory;
  final String productDescription;
  const SingleProductCard(
      {super.key,
      required this.productName,
      required this.productPrice,
      required this.productType,
      required this.productCategory,
      required this.productDescription});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: 150,
          decoration:
              BoxDecoration(color: Colors.orange.shade200, boxShadow: const [
            BoxShadow(color: Colors.grey, offset: Offset(0, 3), blurRadius: 8.0)
          ]),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Name:$productName'),
                Divider(
                  thickness: 2,
                  color: Colors.orange.shade500,
                ),
                Text('Price:$productType'),
                Text('Name:$productCategory'),
                Text('Name:$productDescription'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
