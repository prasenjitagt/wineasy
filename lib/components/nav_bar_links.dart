import 'package:flutter/material.dart';

class NavBarLinks extends StatelessWidget {
  final IconData navLinkIcon;
  final String navLinkName;

  const NavBarLinks({
    super.key,
    required this.navLinkIcon,
    required this.navLinkName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(navLinkIcon, color: Colors.black),
          title: Text(
            navLinkName,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
