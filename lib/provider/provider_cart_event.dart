import 'package:flutter/material.dart';

class ProductEvent {
  String name;
  int price;
  int qty = 1;
  String imageUrl;
  String documentId;
  String salesId;
  String description;
  // ignore: non_constant_identifier_names
  String keterangan_barang;

  ProductEvent({
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

class PCartEvent extends ChangeNotifier {
  final List<ProductEvent> _list = [];
  List<ProductEvent> get getItems {
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
    final productEvent = ProductEvent(
      name: name,
      price: price,
      qty: qty,
      imageUrl: imageUrl,
      documentId: documentId,
      salesId: salesId,
      description: description,
      keterangan_barang: keterangan_barang,
    );
    _list.add(productEvent);
    notifyListeners();
  }

  void increament(ProductEvent productEvent) {
    productEvent.increase();
    notifyListeners();
  }

  void reduceByOne(ProductEvent productEvent) {
    productEvent.decrease();
    notifyListeners();
  }

  void removeItem(ProductEvent productEvent) {
    _list.remove(productEvent);
    notifyListeners();
  }

  void clearCart() {
    _list.clear();
    notifyListeners();
  }
}
