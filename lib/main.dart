import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/edit_product_page.dart';
import 'package:shop/pages/order_page.dart';
import 'package:shop/pages/user_products_page.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/products_overview_page.dart';
import 'package:shop/providers/products.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
              .copyWith(secondary: Colors.deepOrange),
        ),
        initialRoute: "/",
        routes: {
          "/": (context) => const ProductsOverviewPage(),
          ProductDetailPage.route: (context) => const ProductDetailPage(),
          CartPage.route: (context) => const CartPage(),
          OrdersPage.route: (context) => const OrdersPage(),
          UserProductsPage.route: (context) => const UserProductsPage(),
          EditProductPage.route: (context) => EditProductPage(),
        },
      ),
    );
  }
}
