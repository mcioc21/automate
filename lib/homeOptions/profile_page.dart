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
      if (prefs.containsKey('vehicles')) {
        prefs.remove('vehicles'); // Clear the vehicle list
      }
      await prefs.clear();
      if (context.mounted) {
        //Navigator.of(context).popUntil(ModalRoute.withName('/'));
        Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false,);
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

  Future<void> _login(BuildContext context) async {
    try {
      // Navigate to the login screen or handle login logic here
      Navigator.of(context).pushNamed('/login');
      final prefs = await SharedPreferences.getInstance();
      if(prefs.getBool('isGuest') != false) {
        prefs.setBool('isGuest', false);
      }
      if (prefs.containsKey('vehicles')) {
        prefs.remove('vehicles'); // Clear the vehicle list
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Log in was not possible at this time, please try again later.'),
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
                _login(context);
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
