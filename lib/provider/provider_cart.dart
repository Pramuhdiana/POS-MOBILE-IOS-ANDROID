import 'package:flutter/material.dart';

class Product {
  String name;
  int price;
  int qty = 1;
  String imageUrl;
  String documentId;
  String salesId;
  String description;
  // ignore: non_constant_identifier_names
  String keterangan_barang;

  Product({
    required this.name,
    required this.price,
    required this.qty,
    required this.imageUrl,
    required this.documentId,
    required this.salesId,
    required this.description,
    // ignore: non_constant_identifier_names
    required this.keterangan_barang,
  });
  void increase() {
    qty++;
  }

  void decrease() {
    qty--;
  }
}

class PCart extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getItems {
    return _list;
  }

  double get totalPrice {
    var total = 0.0;
    for (var item in _list) {
      total += item.price * item.qty;
    }
    return total;
  }

  int get totalPrice2 {
    var total = 0;
    for (var item in _list) {
      total += item.price * item.qty;
    }
    return total;
  }

  int? get count {
    var tot = _list.length - 0;
    return tot;
  }

  void addItem(
    String name,
    int price,
    int qty,
    String imageUrl,
    String documentId,
    String salesId,
    String description,
    // ignore: non_constant_identifier_names
    String keterangan_barang,
  ) {
    final product = Product(
        name: name,
        price: price,
        qty: qty,
        imageUrl: imageUrl,
        documentId: documentId,
        salesId: salesId,
        description: description,
        keterangan_barang: keterangan_barang);
    _list.add(product);
    notifyListeners();
  }

  void increament(Product product) {
    product.increase();
    notifyListeners();
  }

  void reduceByOne(Product product) {
    product.decrease();
    notifyListeners();
  }

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _list.clear();
    notifyListeners();
  }
}
