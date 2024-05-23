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

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      colorScheme: AppColors.colorScheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: AppColors.snow,
        ),
      ),
      scaffoldBackgroundColor: AppColors.snow,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: SlidePageTransitionsBuilder(),
        TargetPlatform.iOS: FadePageTransitionsBuilder(),
      },
    ),
    );
  }
}

class FadePageTransitionsBuilder extends PageTransitionsBuilder {
  const FadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}

class SlidePageTransitionsBuilder extends PageTransitionsBuilder {
  const SlidePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    var begin = Offset(1.0, 0.0); // Slide from right
    var end = Offset.zero;
    var curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
}