import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wineasy/screens/home.dart';

class PreHome extends StatefulWidget {
  const PreHome({super.key});

  @override
  State<PreHome> createState() => _PreHomeState();
}

class _PreHomeState extends State<PreHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => const Home()));
                },
                child: const Text('Go to Home')),
          ],
        ),
      ),
    );
  }
}
