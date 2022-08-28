import 'package:flutter/material.dart';
import 'package:phone_test/pages/cart_page/cart_page.dart';
import 'package:phone_test/pages/main_page/main_page.dart';
import 'package:phone_test/pages/phone_details_page/phone_datails_page.dart';
import 'package:phone_test/pages/splash_screen.dart/splash_page.dart';
import 'source/AppTheme/AppTheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: getCustomThemeData(),
        // home: const MainPage(),
        // home: const PhoneDetailsPage()
        // home: const CartPage());
        initialRoute: '/splashScreen',
        routes: <String, WidgetBuilder>{
          '/splashScreen': (context) => SplashPage(),
          '/': (context) => const MainPage(),
          '/details': (context) => const PhoneDetailsPage(),
          '/cart': (context) => const CartPage()
        });
  }
}
