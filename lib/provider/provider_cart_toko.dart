import 'package:flutter/material.dart';

class ProductToko {
  String name;
  int price;
  int qty = 1;
  String imageUrl;
  String documentId;
  String salesId;
  String description;
  // ignore: non_constant_identifier_names
  String keterangan_barang;

  ProductToko({
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

class PCartToko extends ChangeNotifier {
  final List<ProductToko> _list = [];
  List<ProductToko> get getItems {
    return _list;
  }

  double get totalPrice {
    var total = 0.0;
    for (var item in _list) {
      total += item.price * item.qty;
    }
    return total;
  }

  double get totalPrice2 {
    var total = 0.0;
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
    final productToko = ProductToko(
      name: name,
      price: price,
      qty: qty,
      imageUrl: imageUrl,
      documentId: documentId,
      salesId: salesId,
      description: description,
      keterangan_barang: keterangan_barang,
    );
    _list.add(productToko);
    notifyListeners();
  }

  void increament(ProductToko productToko) {
    productToko.increase();
    notifyListeners();
  }

  void reduceByOne(ProductToko productToko) {
    productToko.decrease();
    notifyListeners();
  }

  void removeItem(ProductToko productToko) {
    _list.remove(productToko);
    notifyListeners();
  }

  void clearCart() {
    _list.clear();
    notifyListeners();
  }
}
