import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  final User? user;

  const ProfilePage({super.key, this.user});

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('hasSeenWelcomeBanner');
      prefs.remove('hasSeenGuestBanner');
      if (context.mounted) {
        Navigator.of(context).popUntil(ModalRoute.withName('/'));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Log out was not possible at this time, please try again later.'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(user?.email ?? 'No user logged in'),
          ElevatedButton(
            onPressed: () {
              if (user != null) {
                _logout(context);
              } else {
                Navigator.of(context).pushNamed('/login');
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(user != null ? Colors.red : Colors.green),
            ),
            child: Text(user != null ? 'Logout' : 'Log In'),
          ),
        ],
      ),
    );
  }
}
