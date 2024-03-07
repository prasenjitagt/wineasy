import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wineasy/components/side_nav_bar.dart';

class KillSwitch extends StatelessWidget {
  const KillSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final orderDataBox = Hive.box('orderDataBox');

    return Scaffold(
      drawer: const SideNavBar(),
      body: Center(
        child: TextButton(
            onPressed: () {
              orderDataBox.delete('orderData');
            },
            child: const Text(
              "Destroy Hive",
              style: TextStyle(fontSize: 50),
            )),
      ),
    );
  }
}
