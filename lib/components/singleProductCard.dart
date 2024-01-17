import 'package:flutter/material.dart';

class SingleProductCard extends StatelessWidget {
  final String productName;
  final String productPrice;
  final String productType;
  final String productCategory;
  final String productDescription;

  const SingleProductCard({
    Key? key,
    required this.productName,
    required this.productPrice,
    required this.productType,
    required this.productCategory,
    required this.productDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: 150,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey, offset: Offset(0, 3), blurRadius: 8.0)
            ],
          ),
          child: Center(
            child: DataTable(
              columns: [
                DataColumn(label: Text('Property')),
                DataColumn(label: Text('Value')),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text('Name')),
                  DataCell(Text(productName)),
                ]),
                DataRow(cells: [
                  DataCell(Text('Price')),
                  DataCell(Text(productPrice)),
                ]),
                DataRow(cells: [
                  DataCell(Text('Type')),
                  DataCell(Text(productType)),
                ]),
                DataRow(cells: [
                  DataCell(Text('Category')),
                  DataCell(Text(productCategory)),
                ]),
                DataRow(cells: [
                  DataCell(Text('Description')),
                  DataCell(Text(productDescription)),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
