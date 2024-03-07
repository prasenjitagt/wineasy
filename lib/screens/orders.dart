import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wineasy/components/orders_view.dart';
import 'package:wineasy/components/side_nav_bar.dart';
import 'package:wineasy/providers/socket_data_provider.dart';

class Orders extends ConsumerStatefulWidget {
  const Orders({super.key});

  @override
  ConsumerState<Orders> createState() => _OrdersState();
}

class _OrdersState extends ConsumerState<Orders> {
  final orderDataBox = Hive.box('orderDataBox');
  late var orderDataFromHive;

  @override
  void initState() {
    orderDataFromHive = orderDataBox.get('orderData');
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
      body: orderData.when(data: (data) {
        if (orderDataFromHive != null) {
          return OrdersView(orderDataFromHive: orderDataFromHive);
        } else {
          Timer(const Duration(seconds: 1), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Orders()),
            );
          });
          return const Center(
              child: Text(
            "No Orders yet",
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.w600),
          ));
        }
      }, error: (_, __) {
        print(_.toString());
        return const Text('Error');
      }, loading: () {
        if (orderDataFromHive != null) {
          return OrdersView(orderDataFromHive: orderDataFromHive);
        } else {
          return const Center(
              child: Text(
            "No Orders yet",
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.w600),
          ));
        }
      }),
    );
  }
}
