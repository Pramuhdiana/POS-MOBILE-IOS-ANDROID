// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class ApprovalEticketing {
  int qty = 1;

  ApprovalEticketing({
    required this.qty,
  });
  void increase() {
    qty++;
  }

  void decrease() {
    qty--;
  }
}

class PApprovalEticketing extends ChangeNotifier {
  final List<ApprovalEticketing> _list = [];
  List<ApprovalEticketing> get getItems {
    return _list;
  }

  int? get count {
    var tot = _list.length - 0;
    return tot;
  }

  void addItem(
    int qty,
  ) {
    final approvalEticketing = ApprovalEticketing(qty: qty);
    _list.add(approvalEticketing);
    notifyListeners();
  }

  void removesItem() {
    _list.removeLast();
    notifyListeners();
  }

  void increament(ApprovalEticketing approvalEticketing) {
    approvalEticketing.increase();
    notifyListeners();
  }

  void reduceByOne(ApprovalEticketing approvalEticketing) {
    approvalEticketing.decrease();
    notifyListeners();
  }

  void removeItem(ApprovalEticketing approvalEticketing) {
    _list.remove(approvalEticketing);
    notifyListeners();
  }

  void clearNotif() {
    _list.clear();
    notifyListeners();
  }
}
