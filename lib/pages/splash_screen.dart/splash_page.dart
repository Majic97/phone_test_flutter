import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:phone_test/pages/main_page/main_page.dart';
import 'package:phone_test/source/colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainPage(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darklBue,
      body: Container(
          alignment: Alignment.center,
          child: Stack(alignment: Alignment.center, children: [
            const Icon(
              Icons.circle,
              color: customOrange,
              size: 132,
            ),
            Container(
                padding: const EdgeInsets.only(left: 100.0),
                child: const Text(
                  "Ecommerce \nConcept",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900),
                ))
          ])),
    );
  }
}
