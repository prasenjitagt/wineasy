import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:wineasy/components/error_card.dart';

class TodaysStats extends StatefulWidget {
  const TodaysStats({super.key});

  @override
  State<TodaysStats> createState() => _TodaysStatsState();
}

class _TodaysStatsState extends State<TodaysStats> {
  List<dynamic>? todaySales;
  int highestCount = 0;
  String mostSoldProduct = "Loading";
  String totalRevenueOfSingleFood = "0.00";
  @override
  void initState() {
    fetchSalesData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: todaySales == null
            ? const Center(child: Text('No Categories yet'))
            : Row(
                children: [
                  SizedBox(
                    width: 250,
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
                                        color:
                                            Colors.deepPurple.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Icon(
                                      Icons.arrow_upward,
                                      color: Colors.deepPurple.shade800,
                                      size: 35,
                                    ),
                                  ),
                                ),
                                //Its a Gap withing arrow and Most Sold Item
                                const SizedBox(
                                  width: 15,
                                ),
                                const Text(
                                  "Today's Most Sold Item",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
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
                                    mostSoldProduct,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal),
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
                                  '₹$totalRevenueOfSingleFood',
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
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
                                      'Qty. $highestCount',
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
                  )
                ],
              ));
  }

  // Function to fetch sales data from the server
  void fetchSalesData() async {
    const String getSalesUrl = "http://localhost:4848/api/get-sales";
    try {
      Response serverResponse =
          await Dio().get(getSalesUrl, queryParameters: {'filter': 'today'});
      if (serverResponse.data.runtimeType == List) {
        setState(() {
          todaySales = serverResponse.data;
        });

        calculateMostSoldProduct();
      } else if (serverResponse == 204) {
        setState(() {
          todaySales = null;
        });
      } else {
        setState(() {
          todaySales = null;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');

      rethrow;
    }
  }

  //for calculating most sold
  calculateMostSoldProduct() async {
    Map<String, int> productItemCount = {};
    int productPrice = 0;
    if (todaySales != null) {
      for (var order in todaySales!) {
        for (var orderItem in order['orderItems']) {
          String productName = orderItem['item']['productName'];
          int itemCount = orderItem['itemCount'];
          productPrice = int.parse(orderItem['item']['price']);

          productItemCount.update(
            productName,
            (count) => count + itemCount,
            ifAbsent: () => itemCount,
          );
        }
      }

      productItemCount.forEach((productName, itemCount) {
        if (itemCount > highestCount) {
          highestCount = itemCount;
          mostSoldProduct = productName;
        }
      });

      //Multipling Product Price with Qty
      productPrice = productPrice * highestCount;
      double decimalProductPrice = productPrice / 100;

      // storing the convert rupees result
      totalRevenueOfSingleFood = decimalProductPrice.toStringAsFixed(2);
    } else {
      print('reached else');
    }
  }
}
