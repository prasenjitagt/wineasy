import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PastThirtyDaysStats extends StatefulWidget {
  const PastThirtyDaysStats({super.key});

  @override
  State<PastThirtyDaysStats> createState() => _PastThirtyDaysStatsState();
}

class _PastThirtyDaysStatsState extends State<PastThirtyDaysStats> {
  List<dynamic>? past30DaysSales;

  //for Grand Total
  int totalItemCount = 0;
  String grandTotalRevenue = "0.00";

  //for most sold item
  String mostSoldProduct = "Loading";
  String totalRevenueOfMostSoldFood = "0.00";
  int mostSoldProductQty = 0;
  @override
  void initState() {
    fetchSalesData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return past30DaysSales == null
        ? const Center(child: Text('No Categories yet'))
        : Center(child: Text(mostSoldProduct));
  }

  // Function to fetch sales data from the server
  void fetchSalesData() async {
    const String getSalesUrl = "http://localhost:4848/api/get-sales";
    try {
      Response serverResponse = await Dio()
          .get(getSalesUrl, queryParameters: {'filter': 'past30days'});
      if (serverResponse.data.runtimeType == List) {
        setState(() {
          past30DaysSales = serverResponse.data;
        });

        calculateTotalSales();
      } else if (serverResponse == 204) {
        setState(() {
          past30DaysSales = null;
        });
      } else {
        setState(() {
          past30DaysSales = null;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');

      rethrow;
    }
  }

  //for calculating most sold
  calculateTotalSales() async {
    Map<String, int> productItemCount = {};
    int grandTotalRevenueInPaise = 0;
    int productPrice = 0;
    if (past30DaysSales != null) {
      for (var order in past30DaysSales!) {
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
}
