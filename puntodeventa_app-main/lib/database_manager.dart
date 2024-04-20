import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DatabaseManager {
  static final DatabaseManager _singleton = DatabaseManager._internal();

  factory DatabaseManager() {
    return _singleton;
  }

  DatabaseManager._internal();

  void init() async {
    await Hive.initFlutter();
    // Aquí puedes inicializar tus cajas de Hive
  }

  Future<Box> openBox(String boxName) async {
    return await Hive.openBox(boxName);
  }

  Future<List<Map>> getAll(String boxName) async {
    Box box = await Hive.openBox(boxName);
    List<Map> products = [];
    for (var i = 0; i < box.length; i++) {
      products.add(box.getAt(i));
    }
    return products;
  }

  void addProduct(String boxName, int id, String name, int quantity, double price) async {
    var box = await Hive.openBox(boxName);
    box.put(id, {'id': id, 'name': name, 'quantity': quantity, 'price': price});
    var tam = await Hive.box(boxName).length;
    print('Tamaño de la caja: $tam');
  }

  Future<Map> getProduct(String boxName, int id) async {
  Box box = await Hive.openBox(boxName);
  return box.get(id);
}

  void updateProduct(String boxName, int id, String name, int quantity, double price) async {
    Box box = await Hive.openBox(boxName);
    box.put(id, {'id': id, 'name': name, 'quantity': quantity, 'price': price});
  }

  void deleteProduct(String boxName, int id) async {
    Box box = await Hive.openBox(boxName);
    box.delete(id);
  }

  void closeBox(String boxName) {
    Hive.box(boxName).close();
  }
}