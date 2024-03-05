import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './screens/orders.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wineasy/screens/test.dart';
import 'package:wineasy/services/socket_service.dart';

void main() async {
  //starting socket connection
  await Hive.initFlutter();
  var orderDataBox = await Hive.openBox('orderDataBox');
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
        home: const Orders());
  }
}
