import 'package:flutter/material.dart';
import 'package:mccounting_text/mccounting_text.dart';

class CardOfTodaysStats extends StatelessWidget {
  final String title;
  final String productName;
  final String productTotalRevenue;
  final int productSoldQty;
  final Icon titleIcon;
  const CardOfTodaysStats(
      {super.key,
      required this.title,
      required this.productName,
      required this.productTotalRevenue,
      required this.productSoldQty,
      required this.titleIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      constraints: BoxConstraints(minHeight: 180),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 8.0,
            left: 8.0,
          ),
          child: Column(
            children: [
              // Arrow Icon and Most Sold Item text
              Row(
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.deepPurple.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8)),
                        child: titleIcon),
                  ),
                  //Its a Gap withing arrow and Most Sold Item
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  )
                ],
              ),

              //Its a Gap between Most Sold Item and Food Product Name
              const SizedBox(
                height: 10,
              ),

              //Product Name and Count
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      productName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
              //Its a Gap between  Food Product Name and Total Revenue
              const SizedBox(
                height: 10,
              ),

              //Price and Quantity
              Row(
                children: [
                  Text(
                    '₹$productTotalRevenue',
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 2.0, left: 4.0, right: 4.0),
                      child: Text(
                        'Qty. $productSoldQty',
                        style: TextStyle(
                            color: Colors.green.shade800,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
