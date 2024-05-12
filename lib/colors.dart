import 'package:flutter/material.dart';

class AppColors {
  static const Color blue = Color(0xFF464d77); 
  static const Color teal = Color(0xFF36827f);
  static const Color yellow = Color(0xFFf9db6d);
  static const Color snow = Color(0xFFf4eded);
  static const Color beaver = Color(0xFF877666);

  static const ColorScheme colorScheme = ColorScheme(
    primary: blue,
    onPrimary: snow,

    secondary: teal,
    onSecondary: snow,

    tertiary: yellow,
    onTertiary: beaver,

    surface: snow,
    onSurface: blue,

    background: snow,
    onBackground: blue,

    error: Colors.red,
    onError: Colors.white,

    brightness: Brightness.light,
  );
}
