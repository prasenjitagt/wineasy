import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wineasy/providers/is_products_changed_provider.dart';
import 'package:wineasy/screens/dashboard.dart';
import 'package:wineasy/screens/products.dart';
import 'package:wineasy/screens/test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => IsProductChangedProvider())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
            useMaterial3: true,
          ),
          home: const Scaffold(
            // body: Test(),
            body: Products(),
          )),
    );
  }
}
