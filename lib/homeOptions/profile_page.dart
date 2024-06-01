import 'package:automate/login_or_register.dart';
import 'package:automate/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  final GlobalKey<NavigatorState>? navigatorKey;

  const ProfilePage({super.key, this.navigatorKey});

  Future<void> _logout(BuildContext context) async {
    try {
      await context.read<UserProvider>().logout();
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
      
      // Notify listeners immediately after logout
      context.read<UserProvider>().notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Log out was not possible at this time, please try again later.'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _login(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const LoginOrRegisterPage())
    );

    // Check if the user has logged in successfully
    if (result == true) {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('vehicles')) {
        prefs.remove('vehicles'); // Clear the vehicle list
      }
      prefs.clear();
      
      // Notify listeners immediately after login
    }
    context.read<UserProvider>().notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      body: user == null
          ? _buildGuestView(context)
          : _buildUserView(context, user),
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('No user logged in'),
          ElevatedButton(
            onPressed: () => _login(context),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),
            child: const Text('Log In / Sign Up'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserView(BuildContext context, User user) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(user.email ?? 'User'),
          ElevatedButton(
            onPressed: () => _logout(context),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
