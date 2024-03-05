import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wineasy/providers/socket_data_provider.dart';
import '../components/side_nav_bar.dart';

class Test extends ConsumerStatefulWidget {
  const Test({super.key});

  @override
  ConsumerState<Test> createState() => _TestState();
}

class _TestState extends ConsumerState<Test> {
  List<dynamic>? todaySales;

  @override
  void initState() {
    fetchOrdersData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = ref.watch(providerOfSocket);

    return Scaffold(
      drawer: const SideNavBar(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: orderData.when(
          data: (data) {
            setState(() {
              fetchOrdersData();
            });
            return todaySales == null
                ? const Center(
                    child: Text(
                    'No Orders Yet ',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.w700),
                  ))
                : Text('$todaySales');
          },
          error: (_, __) {
            print(_.toString());
            return const Text('Error');
          },
          loading: () => const Center(
                  child: Text(
                'No Orders Yet ',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w700),
              ))),
    ); // Hello world
  }

  // Function to fetch sales data from the server
  void fetchOrdersData() async {
    const String getSalesUrl = "http://localhost:4848/api/get-sales";
    try {
      Response serverResponse =
          await Dio().get(getSalesUrl, queryParameters: {'filter': 'today'});
      if (serverResponse.data.runtimeType == List) {
        todaySales = serverResponse.data;
      } else if (serverResponse == 204) {
        todaySales = null;
      } else {
        todaySales = null;
      }
    } catch (e) {
      print('Error fetching data: $e');

      rethrow;
    }
  }
}
