import 'package:automate/homeOptions/vehicleOptions/fuel_type.dart';

class Vehicle {
  final String? uid;
  final String make;
  final String model;
  final String vinNumber;
  final FuelType fuelType;

  Vehicle({
    this.uid,
    required this.make,
    required this.model,
    required this.vinNumber,
    required this.fuelType,
  });

  // Convert a map to a Vehicle object
  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      uid: map['uid'] ?? '',
      make: map['make'] ?? '',
      model: map['model'] ?? '',
      vinNumber: map['vinNumber'] ?? '',
      fuelType: FuelType.values.byName(map['fuelType'] ?? 'Undefined'), // Default to 'Petrol' if not specified
    );
  }

  // Convert a Vehicle object to a map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'make': make,
      'model': model,
      'vinNumber': vinNumber,
      'fuelType': fuelType.name, // Store the name of the enum value
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