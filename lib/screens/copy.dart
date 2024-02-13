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
  String? mostSoldProduct;
  @override
  void initState() {
    fetchSalesData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: MediaQuery.of(context).size.width,
      child: todaySales == null
          ? const Center(child: Text('No Categories yet'))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: todaySales!.length,
              itemBuilder: ((context, index) {
                return Text('${index + 1}data');
              })),
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

    if (todaySales != null) {
      for (var order in todaySales!) {
        for (var orderItem in order['orderItems']) {
          String productName = orderItem['item']['productName'];
          int itemCount = orderItem['itemCount'];

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

      print('$mostSoldProduct $highestCount');
    } else {
      print('reached else');
    }
  }
}
