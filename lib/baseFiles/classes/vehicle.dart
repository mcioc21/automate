// ignore_for_file: avoid_print

import 'package:automate/homeOptions/vehicleOptions/fuel_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Vehicle {
  final String? uid;
  final String make;
  final String model;
  final String vinNumber;
  final FuelType fuelType;
  bool isDefault; // New attribute for default status

  Vehicle({
    this.uid,
    required this.make,
    required this.model,
    required this.vinNumber,
    required this.fuelType,
    this.isDefault = false, // Default value for isDefault
  });

  // Convert a map to a Vehicle object
  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      uid: map['uid'] ?? '',
      make: map['make'] ?? '',
      model: map['model'] ?? '',
      vinNumber: map['vinNumber'] ?? '',
      fuelType: FuelType.values.byName(map['fuelType'] ?? 'Petrol'), // Default to 'Petrol' if not specified
      isDefault: map['isDefault'] ?? false, // Default to false if not specified
    );
  }

  // Convert a Vehicle object to a map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'make': make,
      'model': model,
      'vinNumber': vinNumber,
      'fuelType': fuelType.name,
      'isDefault': isDefault, // Include isDefault in the map
    };
  }

  // Convert a list of Vehicles to a list of maps
  static List<Map<String, dynamic>> toMapList(List<Vehicle> vehicles) {
    return vehicles.map((vehicle) => vehicle.toMap()).toList();
  }

  // Convert a list of maps to a list of Vehicles
  static List<Vehicle> fromMapList(List<dynamic> maps) {
    return maps.map((map) => Vehicle.fromMap(map as Map<String, dynamic>)).toList();
  }
}

Future<String?> getVehicleNameByUid(String vehicleUid) async {
  try {
    // Access the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    // Get the vehicle document by UID
    DocumentSnapshot doc = await firestore.collection('users').doc(user?.uid).collection('vehicles').doc(vehicleUid).get();

    if (doc.exists) {
      // Convert the document into a Vehicle object
      Vehicle vehicle = Vehicle.fromMap(doc.data() as Map<String, dynamic>);

      // Return the full name of the vehicle, which is a combination of make and model
      return '${vehicle.make} ${vehicle.model}';
    } else {
      // Return null if the vehicle does not exist
      print('No vehicle found with UID: $vehicleUid');
      return null;
    }
  } catch (e) {
    // Log any errors that occur during the fetch operation
    print('Error fetching vehicle by UID: $e');
    return null;
  }
}

Future<Vehicle> fetchDefaultVehicle(User? user) async {
  try {
    // Access the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Get the default vehicle for the current user
    QuerySnapshot querySnapshot = await firestore.collection('users').doc(user?.uid).collection('vehicles').where('isDefault', isEqualTo: true).get();

    if (querySnapshot.docs.isNotEmpty) {
      // Convert the document into a Vehicle object
      Vehicle vehicle = Vehicle.fromMap(querySnapshot.docs.first.data() as Map<String, dynamic>);

      // Return the default vehicle
      return vehicle;
    } else {
      // Return a default vehicle if no default vehicle is found
      return Vehicle(
        make: 'Unknown',
        model: 'Unknown',
        vinNumber: 'Unknown',
        fuelType: FuelType.Petrol,
        isDefault: true,
      );
    }
  } catch (e) {
    // Log any errors that occur during the fetch operation
    print('Error fetching default vehicle: $e');
    return Vehicle(
      make: 'Unknown',
      model: 'Unknown',
      vinNumber: 'Unknown',
      fuelType: FuelType.Petrol,
      isDefault: true,
    );
  }
}

Future<bool> userHasVehicles(User? user) async {
  try {
    // Access the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Get the vehicles for the current user
    QuerySnapshot querySnapshot = await firestore.collection('users').doc(user?.uid).collection('vehicles').get();

    // Return true if the user has at least one vehicle
    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    // Log any errors that occur during the fetch operation
    print('Error fetching user vehicles: $e');
    return false;
  }
}
