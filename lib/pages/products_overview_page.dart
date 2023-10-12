import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/products_grid.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/badge.dart';

enum FilterOptions {
  favorite,
  all,
}

class ProductsOverviewPage extends StatefulWidget {
  const ProductsOverviewPage({super.key});

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  var _showOnlyFavorites = false;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProduts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions value) {
              setState(() {
                if (value == FilterOptions.all) {
                  _showOnlyFavorites = false;
                } else {
                  _showOnlyFavorites = true;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => const [
              PopupMenuItem(
                child: Text("Favorite"),
                value: FilterOptions.favorite,
              ),
              PopupMenuItem(
                child: Text("All"),
                value: FilterOptions.all,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (context, cart, child) => BadgeW(
              child: child!,
              value: cart.cartItemsCount.toString(),
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartPage.route);
              },
            ),
          ),
        ],
        title: const Text("Our shop"),
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(
              showFavorite: _showOnlyFavorites,
            ),
    );
  }
}
