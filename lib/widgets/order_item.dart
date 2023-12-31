import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as provider;

class OrderItem extends StatefulWidget {
  final provider.OrderItem order;

  const OrderItem({
    required this.order,
    super.key,
  });

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("${widget.order.amount} ₽"),
            subtitle: Text(
                DateFormat("dd.MM.yyyy hh:mm").format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: widget.order.products
                      .map(
                        (product) => Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${product.productTitle}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "${product.price} ₽",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "${product.quantity}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            const Divider(),
                          ],
                        ),
                      )
                      .toList()),
            )
        ],
      ),
    );
  }
}
