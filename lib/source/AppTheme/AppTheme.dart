import 'package:flutter/material.dart';

ThemeData getCustomThemeData() {
  return ThemeData(
      primarySwatch: const MaterialColor(0xFF010035, appColorMap),
      backgroundColor: const Color(0xFFF8F8F8),
      fontFamily: "MarkPro",
      colorScheme: colorScheme(),
      appBarTheme: const AppBarTheme(
          actionsIconTheme: IconThemeData(color: Color(0xFFFF6E4E)),
          // backgroundColor: Color(0x00FFFFFF),
          iconTheme: IconThemeData(color: Color(0xFFFFFFFF))),
      bottomAppBarColor: const Color(0xFF010035));
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
      primary: const Color(0xFF010035),
      onPrimary: Colors.white,
      secondary: const Color(0xFFFF6E4E),
      onSecondary: Colors.white,
      error: Colors.red[600]!,
      onError: Colors.white,
      background: const Color(0xFFF8F8F8),
      onBackground: Colors.white,
      surface: Colors.white,
      onSurface: const Color(0xFF010035));
}
