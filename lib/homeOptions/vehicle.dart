import 'package:flutter/material.dart';

class Vehicle {
  final String name;
  final String vinNumber;

  Vehicle({
    required this.name,
    required this.vinNumber,
  });

  // Convert a map to a Vehicle object
  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      name: map['name'] ?? '',
      vinNumber: map['vinNumber'] ?? '',
    );
  }

  // Convert a Vehicle object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'vinNumber': vinNumber,
    };
  }
}
