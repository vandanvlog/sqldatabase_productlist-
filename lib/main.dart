import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sql_database/pages/add_edit_product.dart';
import 'package:sql_database/pages/home_page.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: "Sqldata",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
