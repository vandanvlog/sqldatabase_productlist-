import 'package:sqflite/sqflite.dart';
import 'package:sql_database/models/model.dart';

class ProductModel extends Model {
  static String tables = "products";

  int? id;

  int? categoryId;
  String productName;
  String? productDesc;
  double? price;
  String? productPic;

  ProductModel({
    this.id,
    required this.productName,
    required this.categoryId,
    this.productDesc,
    this.price,
    this.productPic,
  });

  static ProductModel fromMap(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      productName: json['productName'].toString(),
      categoryId: json['categoryId'],
      productDesc: json['productDesc'].toString(),
      price: json['price'],
      productPic: json['productPic'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id,
      'productName': productName,
      'categoryId': categoryId,
      'productDesc': productDesc,
      'price': price,
      'productPic': productPic,
    };
    if(id!= null){
      map['id'] = id;

    }
    return map;
  }
}
