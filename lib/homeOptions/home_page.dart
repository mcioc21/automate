import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final User? user;

  const HomePage({super.key, this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showWelcomeBanner = false;
  bool _showGuestBanner = false;

  @override
  void initState() {
    super.initState();
    _checkWelcomeBannerStatus();
  }

  Future<void> _checkWelcomeBannerStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenWelcomeBanner = prefs.getBool('hasSeenWelcomeBanner') ?? false;
    final hasSeenGuestBanner = prefs.getBool('hasSeenGuestBanner') ?? false;

    if (widget.user != null && !hasSeenWelcomeBanner) {
      setState(() {
        _showWelcomeBanner = true;
      });
      prefs.setBool('hasSeenWelcomeBanner', true);
    } else if (widget.user == null && !hasSeenGuestBanner) {
      setState(() {
        _showGuestBanner = true;
      });
      prefs.setBool('hasSeenGuestBanner', true);
    }

    Timer(const Duration(seconds: 5), () {
      setState(() {
        _showWelcomeBanner = false;
        _showGuestBanner = false;
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
                  color: Colors.grey, // Color for registered user banner
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(12.0),
                child: const Text(
                  'Welcome to our app!',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          if (_showGuestBanner)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey, // Color for guest user banner
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
