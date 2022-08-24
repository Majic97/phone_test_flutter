import 'package:flutter/material.dart';
import 'package:phone_test/pages/main_page/main_page.dart';
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
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const MainPage(),
    );
  }
}
