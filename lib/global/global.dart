import 'package:e_shop/assistantMethods/cart_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;

CartMethods cartMethods = CartMethods();
// SearchScreens searchScreens = SearchScreens();
// if (sharedPreferences!.getString("role")! != "SALES")
String fcmTokenJonathan = "spxOYelPKaZ33WKvoFvWuL3k7uB2";
String fcmTokenErick = "fUS5v8s9XRPLYP3mYVNEgH6BCAp2";
String fcmServerToken =
    "AAAAu6dblLA:APA91bEanz7VkI6wyJSxAGE8L1lVDFcv5VWg_9qlVsuRUwXUtoXmK5apL0fYMSOdDqt_OEL8uQhfBDJvFMJmwHYm3n0aav4z4Dg56tfsnkyZobqCwtGLO6PM0WBb2vsA_XtakPNIKJQT";

String? id = sharedPreferences!.getString('id');
String? token = sharedPreferences!.getString('token');
int revisiBesar =
    1; //UI baru, banyak fitur baru, perubahan konsep, dll  (MAJOR)
int revisiKecil =
    5; //perubahan kecil                                    (MINOR)
int rilisPerbaikanbug =
    0; //perbaikan bug                                      (PATCH)

String version = 'v$revisiBesar.$revisiKecil.$rilisPerbaikanbug';
