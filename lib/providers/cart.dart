import 'package:flutter/foundation.dart';
import 'package:shop/providers/product.dart';

class CartItem {
  final String id;
  final String productId;
  final String productTitle;

  final int quantity;
  late final double price;

  CartItem({
    required this.id,
    required this.productId,
    required this.productTitle,
    required double productPrice,
    required this.quantity,
  }) {
    price = productPrice * quantity;
  }

  CartItem.priced({
    required this.id,
    required this.productId,
    required this.productTitle,
    required this.price,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  final Map<String, CartItem> _order = {};

  Map<String, CartItem> get order => _order;

  int get cartItemsCount => _order.length;

  double get totalAmount {
    double result = 0;

    for (var cartItem in _order.values) {
      result += cartItem.price;
    }

    return result;
  }

  void removeProductFromCart(String productId) {
    _order.remove(productId);
    notifyListeners();
  }

  void removeSingleProduct(String productId) {
    if (!_order.containsKey(productId)) {
      return;
    }
    if (_order[productId]!.quantity > 1) {
      _order.update(
          productId,
          (cartItem) => CartItem.priced(
              id: cartItem.id,
              productId: cartItem.id,
              productTitle: cartItem.productTitle,
              price: cartItem.price,
              quantity: cartItem.quantity - 1));
    } else {
      _order.remove(productId);
    }
  }

  void addProductToCart(Product product) {
    if (_order.containsKey(product.id)) {
      _order.update(
          product.id!,
          (cartItem) => CartItem(
              id: cartItem.id,
              productId: product.id!,
              productTitle: product.title,
              productPrice: product.price,
              quantity: cartItem.quantity + 1));
    } else {
      _order.putIfAbsent(
        product.id!,
        () => CartItem(
          id: DateTime.now().toString(),
          productId: product.id!,
          productTitle: product.title,
          productPrice: product.price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void clear() {
    _order.clear();
    notifyListeners();
  }
}
