import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailPage extends StatelessWidget {
  static const String route = "/productDetails";
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Product product = ModalRoute.of(context)!.settings.arguments as Product;
    final productId = ModalRoute.of(context)!.settings.arguments as String;

    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.network(
              loadedProduct.ImageURL,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text("${loadedProduct.price} ₽",
              style: const TextStyle(color: Colors.grey, fontSize: 25)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Text(
              loadedProduct.description,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          )
        ],
      )),
    );
  }
}
