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

  List<Color> gradientColors = [Colors.cyan, Colors.blue];

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
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
      ),
      child: past30DaysSales == null
          ? const Center(child: Text('No Categories yet'))
          : SizedBox(
              width: 500,
              height: 300,
              child: LineChart(LineChartData(
                lineTouchData: const LineTouchData(enabled: true),
                gridData: FlGridData(
                  show: false,
                  getDrawingVerticalLine: (value) {
                    return const FlLine(
                      color: Colors.blue,
                      strokeWidth: 1,
                    );
                  },
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Colors.blue,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: bottomTitleWidgets,
                      interval: 1,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                  border: Border.all(color: const Color(0xff37434d)),
                ),
                minX: 0,
                maxX: 29,
                minY: 0,
                lineBarsData: [
                  LineChartBarData(
                    spots: spotsForLineCharts(),
                    gradient: LinearGradient(
                      colors: [
                        ColorTween(
                                begin: gradientColors[0],
                                end: gradientColors[1])
                            .lerp(0.2)!,
                        ColorTween(
                                begin: gradientColors[0],
                                end: gradientColors[1])
                            .lerp(0.2)!,
                      ],
                    ),
                    barWidth: 3,
                    isCurved: true,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(
                      show: false,
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          ColorTween(
                                  begin: gradientColors[0],
                                  end: gradientColors[1])
                              .lerp(0.2)!
                              .withOpacity(0.4),
                          ColorTween(
                                  begin: gradientColors[0],
                                  end: gradientColors[1])
                              .lerp(0.2)!
                              .withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
            ),
    );
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
      } else if (serverResponse.statusCode == 204) {
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
  }

  List<FlSpot> spotsForLineCharts() {
    final List<FlSpot> past30daysRevenue = List.generate(revenueByDay.length,
        (index) => FlSpot(index.toDouble(), revenueByDay[index] / 100));

    return past30daysRevenue;
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('DAY 1', style: style);
        break;
      case 5:
        text = const Text('DAY 6', style: style);
        break;
      case 10:
        text = const Text('DAY 11', style: style);
        break;
      case 15:
        text = const Text('DAY 16', style: style);
        break;
      case 20:
        text = const Text('DAY 21', style: style);
        break;
      case 25:
        text = const Text('DAY 26', style: style);
        break;
      case 29:
        text = const Text(
          'DAY 30',
          style: style,
        );
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
}
