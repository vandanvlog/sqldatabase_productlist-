import 'package:sql_database/models/products_model.dart';
import 'package:sql_database/models/utils/db_helper.dart';

class DbService {
  Future<List<ProductModel>> getProducts() async {
    await DBHelper.init();

    List<Map<String, dynamic>> products =
    await DBHelper.query(ProductModel.tables);
    return products.map((item) => ProductModel.fromMap(item)).toList();
  }

  Future<bool> addProduct(ProductModel model) async {
    await DBHelper.init();

    int ret = await DBHelper.insert(ProductModel.tables, model);

    return ret > 0 ? true : false;
  }

  Future<bool> updataProduct(ProductModel model) async {
    await DBHelper.init();

    int ret = await DBHelper.updata(ProductModel.tables, model);

    return ret == 1 ? true : false;
  }

  Future<bool> deleteProduct(ProductModel model) async {
    await DBHelper.init();

    int ret = await DBHelper.delete(ProductModel.tables, model);

    return ret == 1 ? true : false;
  }
}