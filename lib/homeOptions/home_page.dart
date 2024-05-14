import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User? user;

  const HomePage({super.key, this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showWelcomeBanner = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      setState(() {
        _showWelcomeBanner = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_showWelcomeBanner)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(12.0),
                child: const Text(
                  'Welcome to our app! Please remember to login/create your account to unlock all the app features!',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Your other widgets here
              ],
            ),
          ),
        ],
      ),
    );
  }
}
