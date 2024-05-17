import 'package:automate/home.dart';
import 'package:automate/login.dart';
import 'package:automate/register.dart';
import 'package:flutter/material.dart';

class NavigationManager {
  static const String login = '/login';
  static const String register = '/register';
  static const String dash = '/dashboard';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
    register: (context) =>  const RegisterPage(),
    dash: (context) =>  const HomeScreen(),
  };

  static void goToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  static void goToHomeWithPage(BuildContext context, {int currentPageIndex = 0}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(currentPageIndex: currentPageIndex),
      ),
    );
  }

  static void goToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  static void goToRegister(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/register');
  }
}
