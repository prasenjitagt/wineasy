import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    final Widthsize = MediaQuery.of(context).size.width;
    final heigtsize = MediaQuery.of(context).size.height;
    return Center(
        child: Column(
      children: [
        Text('height: $heigtsize'),
        Text('width: $Widthsize'),
      ],
    ));
  }
}
