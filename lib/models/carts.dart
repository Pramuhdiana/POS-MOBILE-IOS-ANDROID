import 'package:flutter/material.dart';

class Cart {
  late final int? id;
  final String? productId;
  final String? lot;
  final int? initialPrice;
  final int? productPrice;
  final ValueNotifier<int>? quantity;
  final String? unitTag;
  final String? image;

  Cart(
      {required this.id,
      required this.productId,
      required this.lot,
      required this.initialPrice,
      required this.productPrice,
      required this.quantity,
      required this.unitTag,
      required this.image});

  Cart.fromMap(Map<dynamic, dynamic> data)
      : id = data['id'],
        productId = data['productId'],
        lot = data['lot'],
        initialPrice = data['initialPrice'],
        productPrice = data['productPrice'],
        quantity = ValueNotifier(data['quantity']),
        unitTag = data['unitTag'],
        image = data['image'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'lot': lot,
      'initialPrice': initialPrice,
      'productPrice': productPrice,
      'quantity': quantity?.value,
      'unitTag': unitTag,
      'image': image,
    };
  }

  Map<String, Object?> quantityMap() {
    return {
      'quantity': quantity?.value,
    };
  }
}
