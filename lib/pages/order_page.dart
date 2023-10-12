import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgets/app_drawer.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersPage extends StatelessWidget {
  static const String route = "/orders";
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My payment history"),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx1, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Consumer<Orders>(
              builder: (ctx, orders, _) => ListView.builder(
                itemCount: orders.orders.length,
                itemBuilder: (context, index) {
                  return OrderItem(
                    order: orders.orders[index],
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
