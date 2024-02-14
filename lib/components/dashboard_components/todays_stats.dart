import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:wineasy/components/dashboard_components/card_of_todays_stats.dart';

class TodaysStats extends StatefulWidget {
  const TodaysStats({super.key});

  @override
  State<TodaysStats> createState() => _TodaysStatsState();
}

class _TodaysStatsState extends State<TodaysStats> {
  List<dynamic>? todaySales;
  int mostSoldProductQty = 0;
  int leastSoldProductQty = 10000;
  String mostSoldProduct = "Loading";
  String leastSoldProduct = "Loading";

  String grandTotalRevenue = "0.00";
  int totalItemCount = 0;

  String totalRevenueOfMostSoldFood = "0.00";
  String totalRevenueOfLeastSoldFood = "0.00";
  @override
  void initState() {
    fetchSalesData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return todaySales == null
        ? const Center(child: Text('No Categories yet'))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Most and least sold Item
              Row(
                children: [
                  CardOfTodaysStats(
                    title: "Todays Most Sold Item",
                    productName: mostSoldProduct,
                    productTotalRevenue: totalRevenueOfMostSoldFood,
                    productSoldQty: mostSoldProductQty,
                    titleIcon: Icon(
                      Icons.show_chart_rounded,
                      color: Colors.deepPurple.shade800,
                      size: 35,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  CardOfTodaysStats(
                    title: "Todays Least Sold Item",
                    productName: leastSoldProduct,
                    productTotalRevenue: totalRevenueOfLeastSoldFood,
                    productSoldQty: leastSoldProductQty,
                    titleIcon: Icon(
                      Icons.arrow_downward,
                      color: Colors.deepPurple.shade800,
                      size: 35,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              //Total revenue and qty
              Row(
                children: [
                  CardOfTodaysStats(
                    title: "Todays Total Revenue",
                    productName: "",
                    productTotalRevenue: grandTotalRevenue,
                    productSoldQty: totalItemCount,
                    titleIcon: Icon(
                      Icons.receipt_long_outlined,
                      color: Colors.deepPurple.shade800,
                      size: 35,
                    ),
                  )
                ],
              )
            ],
          );
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
        calculateLeastSoldProduct();
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
  calculateMostSoldProduct() {
    Map<String, int> productItemCount = {};
    int grandTotalRevenueInPaise = 0;
    int productPrice = 0;
    if (todaySales != null) {
      for (var order in todaySales!) {
        for (var orderItem in order['orderItems']) {
          String productName = orderItem['item']['productName'];
          int itemCount = orderItem['itemCount'];
          productPrice = int.parse(orderItem['item']['price']);

          //grand total
          grandTotalRevenueInPaise += productPrice * itemCount;
          //grand Item count
          totalItemCount += itemCount;
          productItemCount.update(
            productName,
            (count) => count + itemCount,
            ifAbsent: () => itemCount,
          );
        }
      }

      //calculating the grand total in
      double decimalGrandTotalRevenue = grandTotalRevenueInPaise / 100;

      //storing convert grandtotal to 2 decimal places
      grandTotalRevenue = decimalGrandTotalRevenue.toStringAsFixed(2);

      productItemCount.forEach((productName, itemCount) {
        if (itemCount > mostSoldProductQty) {
          mostSoldProductQty = itemCount;
          mostSoldProduct = productName;
        }
      });

      //Multipling Product Price with Qty
      productPrice = productPrice * mostSoldProductQty;
      double decimalProductPrice = productPrice / 100;

      // storing the convert rupees result
      totalRevenueOfMostSoldFood = decimalProductPrice.toStringAsFixed(2);
    } else {
      print('reached else');
    }
  }

  //for calculating least sold
  calculateLeastSoldProduct() {
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
        if (itemCount < leastSoldProductQty) {
          leastSoldProductQty = itemCount;
          leastSoldProduct = productName;
        }
      });

      //Multipling Product Price with Qty
      productPrice = productPrice * leastSoldProductQty;
      double decimalProductPrice = productPrice / 100;

      // storing the convert rupees result
      totalRevenueOfLeastSoldFood = decimalProductPrice.toStringAsFixed(2);
    } else {
      print('reached else');
    }
  }
}
