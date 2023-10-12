import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductPage extends StatefulWidget {
  static const String route = "/editProduct";
  EditProductPage({super.key});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  final _imageURLController = TextEditingController();

  final _key = GlobalKey<FormState>();
  Product _newproduct = Product(
    id: null,
    title: "",
    description: "",
    price: -1,
    ImageURL: "",
  );

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;

      if (productId != null) {
        _newproduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _imageURLController.text = _newproduct.ImageURL;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLController.dispose();
    super.dispose();
  }

  void _SaveProduct() async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      if (_newproduct.id == null) {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_newproduct)
            .catchError((error) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Error"),
              content:
                  const Text("An error occurred while creating a new product"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Ok"))
              ],
            ),
          );
        });
      } else {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_newproduct.id!, _newproduct);
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit product"),
        actions: [
          IconButton(
            onPressed: _SaveProduct,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                  key: _key,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _newproduct.title,
                        decoration:
                            const InputDecoration(labelText: "Name of product"),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_priceFocusNode),
                        onSaved: (newValue) {
                          _newproduct = Product(
                              id: _newproduct.id,
                              title: newValue ?? _newproduct.title,
                              description: _newproduct.description,
                              price: _newproduct.price,
                              ImageURL: _newproduct.ImageURL);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter name of product";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _newproduct.price > 0
                            ? _newproduct.price.toString()
                            : "",
                        decoration: const InputDecoration(
                            labelText: "Price of product"),
                        focusNode: _priceFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode),
                        onSaved: (newValue) {
                          _newproduct = Product(
                              id: _newproduct.id,
                              title: _newproduct.title,
                              description: _newproduct.description,
                              price: double.tryParse(newValue!) ??
                                  _newproduct.price,
                              ImageURL: _newproduct.ImageURL);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter price";
                          }
                          if (double.tryParse(value) == null) {
                            return "Enter correct price";
                          }
                          if (double.parse(value) < 0) {
                            return "Enter correct price(more, than 0)";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _newproduct.description,
                        decoration: const InputDecoration(
                            labelText: "Description of product"),
                        focusNode: _descriptionFocusNode,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        onSaved: (newValue) {
                          _newproduct = Product(
                              id: _newproduct.id,
                              title: _newproduct.title,
                              description: newValue ?? _newproduct.description,
                              price: _newproduct.price,
                              ImageURL: _newproduct.ImageURL);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter description";
                          }
                          if (value.length < 10) {
                            return "The description must be more than 10 characters long";
                          }
                          return null;
                        },
                      ),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(
                              top: 10,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageURLController.text.isEmpty
                                ? const Text(
                                    "Enter route to Image",
                                    textAlign: TextAlign.center,
                                  )
                                : Image.network(
                                    _imageURLController.text,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _imageURLController,
                              decoration: const InputDecoration(
                                  labelText: "Link to Image"),
                              onEditingComplete: () {
                                setState(() {});
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter URL to product image";
                                }
                                if (!value.startsWith("http://") &&
                                    !value.startsWith("https://")) {
                                  return "URL must be start with http:// or https://";
                                }
                                if (!value.endsWith(".png") &&
                                    !value.endsWith(".jpg") &&
                                    !value.endsWith(".jpeg")) {
                                  return "URL must be ends on .png/.jpg/.jpeg";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _newproduct = Product(
                                    id: _newproduct.id,
                                    title: _newproduct.title,
                                    description: _newproduct.description,
                                    price: _newproduct.price,
                                    ImageURL: newValue ?? _newproduct.ImageURL);
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
