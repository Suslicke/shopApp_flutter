import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgets/cart_item.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  static const String route = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Корзина"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(children: [
                const Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    "${cart.totalAmount.toStringAsFixed(2)} ₽",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                OrderButton(cart: cart),
              ]),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.order.length,
              itemBuilder: (context, index) => CartItem(
                id: cart.order.values.toList()[index].id,
                title: cart.order.values.toList()[index].productTitle,
                productId: cart.order.keys.toList()[index],
                price: cart.order.values.toList()[index].price,
                quantity: cart.order.values.toList()[index].quantity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.cart.totalAmount <= 0
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addCartToOrders(
                  cartProducts: widget.cart.order.values.toList(),
                  total: widget.cart.totalAmount);
              widget.cart.clear();
              setState(() {
                _isLoading = false;
              });
            },
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const Text("Checkout"),
    );
  }
}
