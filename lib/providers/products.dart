import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

import 'product.dart';

class Products with ChangeNotifier {
  bool _showFavoriteProducts = false;

  List<Product> _items = [];

  List<Product> get items => _items;
  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();
  // .where((product) => (!_showFavoriteProducts || product.isFavorite))
  // .toList();

  // void showAllProducts() {
  //   _showFavoriteProducts = false;
  //   notifyListeners();
  // }

  // void showFavoriteProducts() {
  //   _showFavoriteProducts = true;
  //   notifyListeners();
  // }

  Product findById(String id) =>
      _items.firstWhere((product) => product.id == id);

  Future<void> addProduct(Product product) async {
    const url =
        "https://flutter-shop-learn-96507-default-rtdb.europe-west1.firebasedatabase.app/products.json";
    return http
        .post(
      Uri.parse(url),
      body: json.encode(
        {
          "title": product.title,
          "description": product.description,
          "ImageURL": product.ImageURL,
          "price": product.price,
          "isFavorite": product.isFavorite
        },
      ),
    )
        .catchError((error) {
      print(error);
      throw error;
    }).then(
      (response) {
        Product _newProduct = Product(
          id: json.decode(response.body)["name"],
          title: product.title,
          description: product.description,
          price: product.price,
          ImageURL: product.ImageURL,
        );
        _items.add(_newProduct);
        notifyListeners();
      },
    );
  }

  Future<void> updateProduct(String id, Product product) async {
    final productIndex = _items.indexWhere((prod) => prod.id == id);

    if (productIndex >= 0) {
      final url =
          "https://flutter-shop-learn-96507-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json";

      http.patch(
        Uri.parse(url),
        body: json.encode(
          {
            "title": product.title,
            "description": product.description,
            "ImageURL": product.ImageURL,
            "price": product.price,
          },
        ),
      );

      _items[productIndex] = product;
      notifyListeners();
    } else {
      print("Some error");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        "https://flutter-shop-learn-96507-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json";

    final existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    Product? existingProduct = _items[existingProductIndex];

    _items.removeWhere((product) => product.id == id);
    notifyListeners();

    final response = await http.delete(
      Uri.parse(url),
    );

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete product");
    }

    existingProduct = null;
  }

  Future<void> fetchAndSetProduts() async {
    const url =
        "https://flutter-shop-learn-96507-default-rtdb.europe-west1.firebasedatabase.app/products.json";

    try {
      final response = await http.get(Uri.parse(url));
      final extractedProducts =
          json.decode(response.body) as Map<String, dynamic>;

      List<Product> loadedProducts = [];

      extractedProducts.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            ImageURL: prodData['ImageURL'],
            isFavorite: prodData['isFavorite'],
          ),
        );
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
