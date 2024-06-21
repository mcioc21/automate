import 'package:automate/baseFiles/classes/vehicle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isGuest = false;
  bool _hasSeenWelcomeBanner = false;
  bool _initialized = false;
  SharedPreferences? _prefs;
  List<Vehicle> _vehicles = [];
  Vehicle? _defaultVehicle;
  int _todayAppointmentCount = 0;

  UserProvider() {
    _initUser();
  }

  User? get user => _user;
  bool get isGuest => _isGuest;
  bool get hasSeenWelcomeBanner => _hasSeenWelcomeBanner;
  bool get initialized => _initialized;
  List<Vehicle> get vehicles => _vehicles;
  Vehicle? get defaultVehicle => _defaultVehicle;
  int get appointmentCount => _todayAppointmentCount;

  Future<void> _initUser() async {
    await Firebase.initializeApp();
    _prefs = await SharedPreferences.getInstance();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      _updateUserStatus();
      if (user != null) {  // Fetch default vehicle on user change
        fetchTodayAppointmentsCount();  // Update appointments on user change
      }
      fetchDefaultVehicle(user);
      notifyListeners();
    });

    _initialized = true;  // Set to true once everything is ready
    notifyListeners();  // Notify listeners to re-build UI
  }

  void _updateUserStatus() {
    if (_user == null) {
      _isGuest = _prefs!.getBool('isGuest') ?? false;
      _hasSeenWelcomeBanner = _prefs!.getBool('hasSeenWelcomeBanner') ?? false;
      _todayAppointmentCount = 0;
      _defaultVehicle = null;
    } else {
      _isGuest = false;
      _hasSeenWelcomeBanner = _prefs!.getBool('hasSeenWelcomeBanner') ?? false;
      fetchTodayAppointmentsCount();
      fetchDefaultVehicle(_user);
    }
  }

  void updateVehicles(List<Vehicle> vehicles) {
    _vehicles = vehicles;
    notifyListeners();
  }

  void fetchDefaultVehicle(User? user) async {
    try {
      if(user != null){
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore
          .collection('users').doc(user.uid).collection('vehicles')
          .where('isDefault', isEqualTo: true).get();

      if (querySnapshot.docs.isNotEmpty) {
        _defaultVehicle = Vehicle.fromMap(querySnapshot.docs.first.data() as Map<String, dynamic>);
      } 
      }
      else {
        if(_vehicles.isEmpty) {
          _defaultVehicle = null;
        }
        else {
          _defaultVehicle = _vehicles.first;
        }
      }
      notifyListeners();
    } catch (e) {
      throw Exception('Error fetching default vehicle: $e');
    }
  }

  Future<void> fetchTodayAppointmentsCount() async {
    if (_user != null) {
      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day, 8);

      var querySnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('userId', isEqualTo: _user!.uid)
        .where('dateTime', isGreaterThanOrEqualTo: startOfDay)
        .get();
      _todayAppointmentCount = querySnapshot.docs.length;  // Update the count
      notifyListeners();
    }
    else {
      _todayAppointmentCount = 0;
      notifyListeners();
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
    _defaultVehicle = null;
    notifyListeners();
  }

  void setUser(User? user) {
    _user = user;
    _updateUserStatus();
    notifyListeners();
  }
}
