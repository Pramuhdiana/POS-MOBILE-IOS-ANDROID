import 'package:e_shop/assistantMethods/cart_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;

CartMethods cartMethods = CartMethods();
// SearchScreens searchScreens = SearchScreens();
// if (sharedPreferences!.getString("role")! != "SALES")
String fcmTokenJonathan = "spxOYelPKaZ33WKvoFvWuL3k7uB2";
String fcmTokensandy =
    "fcGgYv7jQYGKjTx9pVz-l5:APA91bGcaCj4xj-36rUa6bdb2G2W1d9oaBuYliPK2wxqbU5XGjOANA-THSziCnx73X0uLmaZVtqNTuhem6aBaeJa0DaZpb7rT-axTxg4iEGyUfrjfQbUv49MPTvJqeoqB23MJnZQlGKz";
String fcmServerToken =
    "AAAAu6dblLA:APA91bEanz7VkI6wyJSxAGE8L1lVDFcv5VWg_9qlVsuRUwXUtoXmK5apL0fYMSOdDqt_OEL8uQhfBDJvFMJmwHYm3n0aav4z4Dg56tfsnkyZobqCwtGLO6PM0WBb2vsA_XtakPNIKJQT";

String? id = sharedPreferences!.getString('id');
String? globalToken = sharedPreferences!.getString('token');
int revisiBesar =
    1; //UI baru, banyak fitur baru, perubahan konsep, dll  (MAJOR)
int revisiKecil =
    9; //perubahan kecil                                    (MINOR)
int rilisPerbaikanbug =
    0; //perbaikan bug                                      (PATCH)

String version = 'v$revisiBesar.$revisiKecil.$rilisPerbaikanbug';
//try dari windows

