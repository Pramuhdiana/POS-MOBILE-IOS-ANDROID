// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class ApprovalBrj {
  int qty = 1;

  ApprovalBrj({
    required this.qty,
  });
  void increase() {
    qty++;
  }

  void decrease() {
    qty--;
  }
}

class PApprovalBrj extends ChangeNotifier {
  final List<ApprovalBrj> _list = [];
  List<ApprovalBrj> get getItems {
    return _list;
  }

  int? get count {
    var tot = _list.length - 0;
    return tot;
  }

  void addItem(
    int qty,
  ) {
    final approvalBrj = ApprovalBrj(qty: qty);
    _list.add(approvalBrj);
    notifyListeners();
  }

  void removesItem() {
    _list.removeLast();
    notifyListeners();
  }

  void increament(ApprovalBrj approvalBrj) {
    approvalBrj.increase();
    notifyListeners();
  }

  void reduceByOne(ApprovalBrj approvalBrj) {
    approvalBrj.decrease();
    notifyListeners();
  }

  void removeItem(ApprovalBrj approvalBrj) {
    _list.remove(approvalBrj);
    notifyListeners();
  }

  void clearNotif() {
    _list.clear();
    notifyListeners();
  }
}
