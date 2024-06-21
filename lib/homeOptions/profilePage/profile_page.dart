import 'package:automate/baseFiles/login_or_register.dart';
import 'package:automate/baseFiles/user_provider.dart';
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
          content: Text(
              'Log out was not possible at this time, please try again later.'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _login(BuildContext context) async {
    final result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const LoginOrRegisterPage()));

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
      body: SafeArea(
        child: user == null
            ? _buildGuestView(context)
            : _buildUserView(context, user),
      ),
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0),
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Icon(Icons.account_circle, size: 50, color: Colors.grey,),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: Guest", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Have a nice day!",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () => _login(context),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  child: const Text('Log In / Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserView(BuildContext context, User user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0),
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              const Icon(Icons.account_circle, size: 50, color: Colors.grey,),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${user.displayName ?? 'User'}",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("Email: ${user.email ?? 'No email available'}",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Have a nice day!",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () => _logout(context),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
