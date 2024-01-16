import 'package:flutter/material.dart';
import 'package:wineasy/components/nav_bar_links.dart';
import 'package:wineasy/screens/add_product.dart';
import 'package:wineasy/screens/dashboard.dart';
import 'package:wineasy/screens/orders.dart';
import 'package:wineasy/screens/products.dart';
import 'package:wineasy/screens/sales.dart';

class SideNavBar extends StatelessWidget {
  const SideNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          closeNavBar(context),
          easyEatzName(),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Dashboard()));
            },
            child: const NavBarLinks(
              navLinkIcon: Icons.dashboard,
              navLinkName: "Dashboard",
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Products()));
            },
            child: const NavBarLinks(
              navLinkIcon: Icons.dining,
              navLinkName: "Your Products",
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const AddProducts()));
            },
            child: const NavBarLinks(
              navLinkIcon: Icons.add_to_queue,
              navLinkName: "Add Product",
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Orders()));
            },
            child: const NavBarLinks(
              navLinkIcon: Icons.analytics,
              navLinkName: "Orders",
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Sales()));
            },
            child: const NavBarLinks(
              navLinkIcon: Icons.business_center,
              navLinkName: "Sales",
            ),
          ),
        ],
      ),
    );
  }

  Center easyEatzName() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(
          top: 20,
        ),
        child: Text(
          "EasyEatz",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w900, color: Colors.red),
        ),
      ),
    );
  }

  Align closeNavBar(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 20, top: 10),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close),
          ),
        ));
  }
}
