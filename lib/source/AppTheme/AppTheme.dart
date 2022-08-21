import 'package:flutter/material.dart';
import 'package:phone_test/source/colors.dart';

ThemeData getCustomThemeData() {
  return ThemeData(
      primarySwatch: const MaterialColor(0xFF010035, appColorMap),
      backgroundColor: backgroundColor,
      fontFamily: "MarkPro",
      colorScheme: colorScheme(),
      appBarTheme: AppBarTheme(
          actionsIconTheme: const IconThemeData(color: customOrange),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: backgroundColor.withOpacity(0),
          titleTextStyle: const TextStyle(
              color: darklBue, fontSize: 15, fontWeight: FontWeight.w500),
          shadowColor: Colors.white.withOpacity(0)),
      bottomAppBarColor: darklBue);
}

const Map<int, Color> appColorMap = {
  50: Color(0xFF010035),
  100: Color(0xFF010035),
  200: Color(0xFF010035),
  300: Color(0xFF010035),
  400: Color(0xFF010035),
  500: Color(0xFF010035),
  600: Color(0xFF010035),
  700: Color(0xFF010035),
  800: Color(0xFF010035),
  900: Color(0xFF010035)
};

ColorScheme colorScheme() {
  return ColorScheme(
      brightness: Brightness.light,
      primary: darklBue,
      onPrimary: Colors.white,
      secondary: customOrange,
      onSecondary: Colors.white,
      error: Colors.red[600]!,
      onError: Colors.white,
      background: backgroundColor,
      onBackground: Colors.white,
      surface: Colors.white,
      onSurface: darklBue);
}
