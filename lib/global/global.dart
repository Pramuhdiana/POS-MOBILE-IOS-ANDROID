import 'package:e_shop/assistantMethods/cart_methods.dart';
import 'package:e_shop/push_notifications/notification_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;

CartMethods cartMethods = CartMethods();
Notification notif = Notification();
// SearchScreens searchScreens = SearchScreens();
// if (sharedPreferences!.getString("role")! != "SALES")
String fcmTokenSales = "";
String fcmTokensandy = "";
String? baseUrlDinamis = sharedPreferences!.getString('urlDinamis');
String fcmServerToken =
    "AAAAu6dblLA:APA91bEanz7VkI6wyJSxAGE8L1lVDFcv5VWg_9qlVsuRUwXUtoXmK5apL0fYMSOdDqt_OEL8uQhfBDJvFMJmwHYm3n0aav4z4Dg56tfsnkyZobqCwtGLO6PM0WBb2vsA_XtakPNIKJQT";

int revisiBesar =
    1; //UI baru, banyak fitur baru, perubahan konsep, dll  (MAJOR)
int revisiKecil =
    1; //perubahan kecil                                    (MINOR)
int rilisPerbaikanbug =
    0; //perbaikan bug                                      (PATCH)
int noBuild = 19; //nobuild                                      (PATCH)

String version = 'v$revisiBesar.$revisiKecil.$rilisPerbaikanbug ($noBuild)';
