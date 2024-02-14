import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PastThirtyDaysStats extends StatefulWidget {
  const PastThirtyDaysStats({super.key});

  @override
  State<PastThirtyDaysStats> createState() => _PastThirtyDaysStatsState();
}

class _PastThirtyDaysStatsState extends State<PastThirtyDaysStats> {
  List<dynamic>? past30DaysSales;
  List<int> revenueByDay = List.filled(30, 0);

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
        : SizedBox(
            width: 500,
            child: LineChart(LineChartData(minX: 0, maxX: 29, lineBarsData: [
              LineChartBarData(spots: const [
                FlSpot(0, 5),
                FlSpot(2, 7),
                FlSpot(4, 9),
                FlSpot(6, 11),
                FlSpot(8, 13),
              ])
            ])),
          );
    ;
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
        caltulationForChart();
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
  calculateTotalSales() {
    Map<String, int> productNameAndItemCount = {};
    int grandTotalRevenueInPaise = 0;
    int productPrice = 0;
    if (past30DaysSales != null) {
      for (var order in past30DaysSales!) {
        for (var orderItem in order['orderItems']) {
          String productName = orderItem['item']['productName'];
          int itemCount = orderItem['itemCount'];

          //particular product price
          productPrice = int.parse(orderItem['item']['price']);

          //grand total
          grandTotalRevenueInPaise += productPrice * itemCount;
          //grand Item count
          totalItemCount += itemCount;
          productNameAndItemCount.update(
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

      productNameAndItemCount.forEach((productName, itemCount) {
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

  caltulationForChart() {
    DateTime todaysDate = DateTime.now();
    past30DaysSales?.forEach((order) {
      DateTime orderDate = DateTime.parse(order["createdAt"]);

      int daysDiff = todaysDate.difference(orderDate).inDays;

      if (daysDiff >= 0 && daysDiff < 30) {
        int index = 29 - daysDiff;
        int totalRevenue = order['orderItems'].fold(0, (prev, item) {
          return prev + int.parse(item['item']['price']) * item['itemCount'];
        });

        revenueByDay[index] += totalRevenue;
      }
    });

    print(revenueByDay);
  }
}
