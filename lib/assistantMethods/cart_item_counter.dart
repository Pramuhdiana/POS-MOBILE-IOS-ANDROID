import 'package:e_shop/global/global.dart';
import 'package:flutter/cupertino.dart';

class CartItemCounter extends ChangeNotifier {
  int cartListItemCounter =
      sharedPreferences!.getStringList("userCart")!.length -
          1; //dikurangi 1 karena di database ada 1
  int get count =>
      cartListItemCounter; // menghitung item yang ada di dalam cart

//menyimpan variabel qty
  Future<void> showCartListItemNumber() async {
    cartListItemCounter =
        sharedPreferences!.getStringList("userCart")!.length - 1;

//update jika ada perubahan
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}

class CartItemCounterToko extends ChangeNotifier {
  int cartListItemCounter =
      sharedPreferences!.getStringList("userCart")!.length -
          1; //dikurangi 1 karena di database ada 1
  int get count =>
      cartListItemCounter; // menghitung item yang ada di dalam cart

//menyimpan variabel qty
  Future<void> showCartListItemNumber() async {
    cartListItemCounter =
        sharedPreferences!.getStringList("userCart")!.length - 1;

//update jika ada perubahan
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
