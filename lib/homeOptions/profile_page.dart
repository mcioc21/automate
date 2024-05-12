import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate back to the login screen or any other desired screen after logout
      if(context.mounted) {
        Navigator.of(context).popUntil(ModalRoute.withName('/')); // Example navigation
      }
    } catch (e) {
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Log out was not possible at this time, please try again later.'),
          duration: Duration(seconds: 5), // Optional: Set the duration to display the snackbar
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
          //Text(FirebaseAuth.instance.currentUser?.uid != null ? 'No user logged in' : FirebaseAuth.instance.currentUser?.email.toString() ?? ''),
          Text(FirebaseAuth.instance.currentUser?.email ?? 'No user logged in'),
          ElevatedButton(
            onPressed: () => _logout(context),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
