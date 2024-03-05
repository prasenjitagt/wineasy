import 'package:flutter/material.dart';
import 'package:wineasy/screens/dashboard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wineasy/screens/orders.dart';
import 'package:wineasy/screens/test2.dart';
import 'package:wineasy/services/socket_service.dart';

void main() {
  //starting socket connection
  SocketService().initConnection();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const Orders(),
    );
  }
}
