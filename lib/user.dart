import 'package:automate/homeOptions/vehicle.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final User user;
  final List<Vehicle> vehicles;

  AppUser({
    required this.user, // alt ctor pentru cazul in care userul nu e logat
    this.vehicles = const [],
  });
}
