import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:wineasy/components/side_nav_bar.dart';

class Sales extends StatefulWidget {
  const Sales({Key? key}) : super(key: key);

  @override
  _SalesState createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  List<dynamic> sales = [];
  String filter = 'today'; // Default filter is today
  DateTime selectedDate = DateTime.now(); // Default selected date is today

  // Function to fetch sales data based on the selected filter
  void fetchSalesData(String selectedFilter) async {
    try {
      // Make HTTP request to backend
      var dio = Dio();
      var response = await dio
          .get('http://localhost:4848/api/get-sales?filter=$selectedFilter');

      // Update state with fetched data
      setState(() {
        filter = selectedFilter; // Update selected filter
        sales = response.data;
      });
    } catch (error) {
      print('Error fetching sales data: $error');
      // Handle error
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSalesData(
        filter); // Fetch data for default filter when the page initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const SideNavBar(),
        appBar: AppBar(
          title: Text('Sales'),
        ),
        body: Text('okay'));
  }
}
