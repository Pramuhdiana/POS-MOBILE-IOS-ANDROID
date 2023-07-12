// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class NewNotification {
  int qty = 1;

  NewNotification({
    required this.qty,
  });
  void increase() {
    qty++;
  }

  void decrease() {
    qty--;
  }
}

class PNewNotif extends ChangeNotifier {
  final List<NewNotification> _list = [];
  List<NewNotification> get getItems {
    return _list;
  }

  int? get count {
    var tot = _list.length - 0;
    return tot;
  }

  void addItem(
    int qty,
  ) {
    final newnotification = NewNotification(qty: qty);
    _list.add(newnotification);
    notifyListeners();
  }

  void removesItem() {
    _list.removeLast();
    notifyListeners();
  }

  void increament(NewNotification newnotification) {
    newnotification.increase();
    notifyListeners();
  }

  void reduceByOne(NewNotification newnotification) {
    newnotification.decrease();
    notifyListeners();
  }

  void removeItem(NewNotification newnotification) {
    _list.remove(newnotification);
    notifyListeners();
  }

  void clearNotif() {
    _list.clear();
    notifyListeners();
  }
}
