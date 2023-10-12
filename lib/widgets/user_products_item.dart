import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/edit_product_page.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class UserProductsItem extends StatelessWidget {
  final Product product;

  const UserProductsItem({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(product.ImageURL),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductPage.route, arguments: product.id);
            },
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          IconButton(
            onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false)
                    .deleteProduct(product.id!);
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("An error occurred while deleting"),
                  ),
                );
              }
            },
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
