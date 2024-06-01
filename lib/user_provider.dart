import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isGuest = false;
  bool _hasSeenWelcomeBanner = false;
  bool _initialized = false;  // Add this line to track initialization status
  SharedPreferences? _prefs;

  UserProvider() {
    _initUser();
  }

  User? get user => _user;
  bool get isGuest => _isGuest;
  bool get hasSeenWelcomeBanner => _hasSeenWelcomeBanner;
  bool get initialized => _initialized;  // Expose the initialization status

  Future<void> _initUser() async {
    await Firebase.initializeApp();
    _prefs = await SharedPreferences.getInstance();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      _updateUserStatus();
      notifyListeners();
    });

    _initialized = true;  // Set to true once everything is ready
    notifyListeners();  // Notify listeners to re-build UI
  }

  void _updateUserStatus() {
    if (_user == null) {
      _isGuest = _prefs!.getBool('isGuest') ?? false;
      _hasSeenWelcomeBanner = _prefs!.getBool('hasSeenWelcomeBanner') ?? false;
    } else {
      _isGuest = false;
      _hasSeenWelcomeBanner = _prefs!.getBool('hasSeenWelcomeBanner') ?? false;
    }
  }

  Future<void> setGuest(bool value) async {
    _isGuest = value;
    await _prefs!.setBool('isGuest', value);
    notifyListeners();
  }

  Future<void> setHasSeenWelcomeBanner(bool value) async {
    _hasSeenWelcomeBanner = value;
    await _prefs!.setBool('hasSeenWelcomeBanner', value);
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await _prefs!.clear();
    _isGuest = false;
    notifyListeners();
  }

  void setUser(User? user) {
    _user = user;
    _updateUserStatus();
    notifyListeners();
  }
}
