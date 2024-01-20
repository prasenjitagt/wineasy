import 'package:flutter/material.dart';
import 'package:wineasy/components/side_nav_bar.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideNavBar(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: const Center(),
    );
  }
}
