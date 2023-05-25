import 'package:flutter/material.dart';
import 'package:sql_database/models/products_model.dart';
import 'package:sql_database/services/db_service.dart';

import 'home_page.dart';

class AddEditProductPage extends StatefulWidget {
  const AddEditProductPage({
    Key? key,
    this.model,
    this.isEditMode = false,
    this.refreshCallback,
  }) : super(key: key);

  final ProductModel? model;
  final bool isEditMode;
  final Function()? refreshCallback;

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  late ProductModel model;
  List<Map<String, dynamic>> categories = [];
  late DbService dbService;

  @override
  void initState() {
    super.initState();
    dbService = DbService();
    model = widget.model ??
        ProductModel(
          productName: '',
          categoryId: -1,
          price: 0.0,
        );

    if (widget.isEditMode) {
      model = widget.model!;
    }

    categories = [
      {'id': 1, 'name': 'T-Shirts'},
      {'id': 2, 'name': 'Pants'},
      {'id': 3, 'name': 'Shirts'},
      {'id': 4, 'name': 'Caps'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: true,
        title: Text(widget.isEditMode ? 'Edit Product' : 'Add Product'),
      ),
      body: Form(
        key: globalKey,
        child: _formUI(),
      ),
      bottomNavigationBar: SizedBox(
        height: 110,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (validateAndSave()) {
                  if (widget.isEditMode) {
                    dbService.updataProduct(model).then((value) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('SQFLITE'),
                            content: const Text('Data modified successfully.'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(),
                                    ),
                                  );
                                  widget.refreshCallback?.call();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    });
                  } else {
                    dbService.addProduct(model).then((value) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('SQFLITE'),
                            content: const Text('Data added successfully.'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(),
                                    ),
                                  );
                                  widget.refreshCallback?.call();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    });
                  }
                }
              },
              child: const Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Product Name',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return '* Required';
                }
                return null;
              },
              onSaved: (value) {
                model.productName = value!.trim();
              },
              initialValue: model.productName,
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Price',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return '* Required';
                }
                return null;
              },
              onSaved: (value) {
                model.price = double.parse(value!);
              },
              initialValue: model.price.toString(),
            ),
            const SizedBox(height: 10),
              DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Category',
              ),
              items: [
                  DropdownMenuItem<int>(
                  value: -1,
                  child: const Text('Select Category'),
                ),
                ...categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category['id'],
                    child: Text(category['name']),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                setState(() {
                  model.categoryId = value!;
                });
              },
              value: model.categoryId == -1 ? null : model.categoryId,
            ),
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
