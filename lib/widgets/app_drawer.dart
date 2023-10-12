import 'package:flutter/material.dart';
import 'package:shop/pages/order_page.dart';
import 'package:shop/pages/user_products_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text("Welcome"),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: const Text("Shop"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text("Payment history"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrdersPage.route);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("My products"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsPage.route);
            },
          ),
        ],
      ),
    );
  }
}
