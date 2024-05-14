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

  // Convert a list of Vehicles to a list of maps
  static List<Map<String, dynamic>> toMapList(List<Vehicle> vehicles) {
    return vehicles.map((vehicle) => vehicle.toMap()).toList();
  }

  // Convert a list of maps to a list of Vehicles
  static List<Vehicle> fromMapList(List<dynamic> maps) {
    return maps.map((map) => Vehicle.fromMap(map)).toList();
  }
}
