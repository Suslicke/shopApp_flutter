import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/product_detail_page.dart';

import '../providers/cart.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  late final BuildContext context;

  ProductItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        // ignore: sort_child_properties_last
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailPage.route, arguments: product.id),
          child: Image.network(
            product.ImageURL,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            iconSize: 25,
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              product.toggleFavoriteStatus();
            },
          ),
          trailing: IconButton(
            iconSize: 25,
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              cart.addProductToCart(product);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("You added product in cart"),
                  duration: const Duration(seconds: 1),
                  action: SnackBarAction(
                      label: "Cancel",
                      onPressed: () {
                        cart.removeSingleProduct(product.id!);
                      }),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
