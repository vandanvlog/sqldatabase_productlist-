import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/list_helper.dart';
import 'package:sql_database/pages/add_edit_product.dart';
import 'package:sql_database/services/db_service.dart';

import '../models/products_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbService dbService = DbService();

  Future<void> refreshProducts() async {
    setState(() {}); // Refresh the page
  }


  @override
  void initState() {
    super.initState();
    dbService = DbService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: FormHelper.submitButton("Add Product", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditProductPage(
                      refreshCallback: refreshProducts,
                    ),
                  ),
                );
              },
                  borderRadius: 10,
                  btnColor: Colors.lightBlue,
                  borderColor: Colors.lightBlue),
            ),

            const SizedBox(
              height: 10,
            ),
            _fetchData()
          ],
        ),
      ),
    );
  }

  Future<void> _refreshProducts() async {
    setState(() {}); // Just to trigger a refresh
  }

  _fetchData() {
    return FutureBuilder<List<ProductModel>>(
        future: dbService.getProducts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductModel>> products) {
          if (products.hasData) {
            return _buildDataTable(products.data!);
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  _buildDataTable(List<ProductModel> model) {
    return ListUtils.buildDataTable(
      context,
      ["Product Name", "price", ""],
      ["productName", "price", ""],
      false,
      0,
      model,
      (ProductModel data) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditProductPage(
                isEditMode: true,
                model: data, refreshCallback: () {},
              ),
            ));
      },
      (ProductModel data) {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Your Product "),
                content: const Text("Delete it ?"),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FormHelper.submitButton("yes", () {
                        dbService.deleteProduct(data).then(
                          (value) {
                            setState(() {
                              Navigator.of(context).pop();
                            });
                          },
                        );
                      }, btnColor: Colors.green),
                      const SizedBox(
                        width: 5,
                      ),
                      FormHelper.submitButton("no", () {
                        Navigator.pop(context);
                      }),
                    ],
                  )
                ],
              );
            });
      },
      headingRowColor: Colors.orangeAccent,
      isScrollable: true,
      columnTextFontSize: 15,
      columnTextBold: false,
      columnSpacing: 50,
      onSort: (columnIndex, columnName, asc) {},
    );
  }
}
