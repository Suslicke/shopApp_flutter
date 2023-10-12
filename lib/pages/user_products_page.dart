import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/edit_product_page.dart';
import 'package:shop/widgets/app_drawer.dart';

import '../providers/products.dart';
import '../widgets/user_products_item.dart';

class UserProductsPage extends StatelessWidget {
  static const String route = "/user_products";
  const UserProductsPage({super.key});

  _refreshProducts(BuildContext context) async {
    Provider.of<Products>(context, listen: false).fetchAndSetProduts();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your's products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductPage.route);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.separated(
            itemCount: productData.items.length,
            itemBuilder: (_, index) => UserProductsItem(
              product: productData.items[index],
            ),
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
      ),
    );
  }
}
