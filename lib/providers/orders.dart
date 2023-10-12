import 'dart:convert';

import 'package:flutter/foundation.dart';
import './cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addCartToOrders(
      {required List<CartItem> cartProducts, required double total}) async {
    const url =
        "https://flutter-shop-learn-96507-default-rtdb.europe-west1.firebasedatabase.app/orders.json";
    final timeStamp = DateTime.now();
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(
        {
          "amount": total,
          "dateTime": timeStamp.toIso8601String(),
          "products": cartProducts
              .map((cp) => {
                    "id": cp.id,
                    "productId": cp.productId,
                    "productTitle": cp.productTitle,
                    "quantity": cp.quantity,
                    "price": cp.price
                  })
              .toList()
        },
      ),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)["name"],
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
  }

  Future<void> fetchAndSetOrders() async {
    const url =
        "https://flutter-shop-learn-96507-default-rtdb.europe-west1.firebasedatabase.app/orders.json";

    final response = await http.get(Uri.parse(url));
    final extractedOrders = json.decode(response.body) as Map<String, dynamic>;

    if (extractedOrders == null) {
      return;
    }
    final List<OrderItem> loadedOrders = [];

    extractedOrders.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
            id: orderId,
            amount: orderData["amount"],
            products: (orderData["products"] as List<dynamic>)
                .map(
                  (item) => CartItem.priced(
                    id: item['id'],
                    productId: item['productId'],
                    productTitle: item['productTitle'],
                    price: item['price'],
                    quantity: item['quantity'],
                  ),
                )
                .toList(),
            dateTime: DateTime.parse(orderData["dateTime"])),
      );
    });

    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
