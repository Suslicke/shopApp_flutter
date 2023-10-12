import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String ImageURL;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.ImageURL,
    this.isFavorite = false,
  });

  void _setFavValue(bool value) {
    isFavorite = value;
    notifyListeners();
  }

  void toggleFavoriteStatus() async {
    final url =
        "https://flutter-shop-learn-96507-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json";

    final oldStatus = isFavorite;
    _setFavValue(!oldStatus);

    try {
      final response = await http.patch(Uri.parse(url),
          body: json.encode({
            "isFavorite": isFavorite,
          }));

      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
