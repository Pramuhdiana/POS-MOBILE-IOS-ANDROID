// import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

import 'package:e_shop/global/global.dart';
import 'package:e_shop/provider/provider_cart.dart';
import 'package:e_shop/provider/provider_cart_event.dart';
import 'package:e_shop/provider/provider_cart_retur.dart';
import 'package:e_shop/provider/provider_cart_toko.dart';
import 'package:e_shop/provider/provider_notification.dart';
import 'package:e_shop/provider/provider_waiting_brj.dart';
import 'package:e_shop/provider/provider_waiting_eticketing.dart';
import 'package:e_shop/splashScreen/my_splas_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  // ignore: avoid_print
  print('No Version : $noBuild');

  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PCart()),
        ChangeNotifierProvider(create: (_) => PCartToko()),
        ChangeNotifierProvider(create: (_) => PCartEvent()),
        ChangeNotifierProvider(create: (_) => PCartRetur()),
        ChangeNotifierProvider(create: (_) => PNewNotif()),
        ChangeNotifierProvider(create: (_) => PApprovalBrj()),
        ChangeNotifierProvider(create: (_) => PApprovalEticketing()),
      ],
      child: OverlaySupport.global(
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.primaryBlack,
          ),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('es'), // Spanish
          ],
          home: const MySplashScreen(),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
