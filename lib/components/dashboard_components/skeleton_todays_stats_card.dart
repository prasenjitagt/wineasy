import 'package:flutter/material.dart';
import 'package:mccounting_text/mccounting_text.dart';

class SkeletonCardOfTodaysStats extends StatelessWidget {
  const SkeletonCardOfTodaysStats({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      constraints: const BoxConstraints(minHeight: 180),
      child: const Card(
          color: Colors.white,
          child: Center(
            child: Text("No Orders Till Now"),
          )),
    );
  }
}
