import 'dart:convert'; // Import for JSON encoding and decoding
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'vehicle.dart'; // Importing the vehicle object
import 'add_vehicle.dart';
import 'edit_vehicle.dart'; // Import the edit vehicle page

class GaragePage extends StatefulWidget {
  final User? user;

  const GaragePage({super.key, this.user});

  @override
  _GaragePageState createState() => _GaragePageState();
}

class _GaragePageState extends State<GaragePage> {
  List<Vehicle> _vehicles = [];

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  // Function to load vehicles from shared preferences if user is not logged in
  Future<void> _loadVehicles() async {
    if (widget.user == null) {
      final prefs = await SharedPreferences.getInstance();
      final String? vehiclesString = prefs.getString('vehicles');

      if (vehiclesString != null) {
        final List<dynamic> vehiclesList = jsonDecode(vehiclesString);
        setState(() {
          _vehicles = Vehicle.fromMapList(vehiclesList);
        });
      }
    }
  }

  // Function to save vehicles to shared preferences if user is not logged in
  Future<void> _saveVehicles() async {
    if (widget.user == null) {
      final prefs = await SharedPreferences.getInstance();
      final String vehiclesString = jsonEncode(Vehicle.toMapList(_vehicles));
      await prefs.setString('vehicles', vehiclesString);
    }
  }

  // Function to clear vehicles from shared preferences
  Future<void> _clearVehicles() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('vehicles');
  }

  // Function to add a new vehicle to the list
  void _addVehicle(String name, String vinNumber) {
    setState(() {
      _vehicles.add(Vehicle(name: name, vinNumber: vinNumber));
      _saveVehicles();
    });
  }

  // Function to remove a vehicle from the list
  void _removeVehicle(int index) {
    setState(() {
      _vehicles.removeAt(index);
      _saveVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _vehicles.isEmpty
          ? const Center(
              child: Text('Add your first vehicle'),
            )
          : ListView.builder(
              itemCount: _vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = _vehicles[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the EditVehiclePage with the corresponding vehicle details
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditVehiclePage(
                            name: vehicle.name,
                            vinNumber: vehicle.vinNumber,
                            editVehicleCallback: (String name, String vinNumber) {
                              setState(() {
                                // Update the vehicle details
                                _vehicles[index] = Vehicle(name: name, vinNumber: vinNumber);
                                _saveVehicles();
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 60, // Adjust the height of the vehicle button
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 20), // Spacing to the left
                              Text(
                                vehicle.name,
                                style: const TextStyle(fontSize: 18.0),
                              ),
                              const Spacer(), // Pushes the delete button to the right edge
                              GestureDetector(
                                onTap: () {
                                  _removeVehicle(index);
                                },
                                child: Container(
                                  width: 40, // Adjust the size of the delete button
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20), // Spacing between text and delete button
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: _vehicles.length < 5
          ? FloatingActionButton(
              onPressed: () {
                // Navigate to the AddVehiclePage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddVehiclePage(addVehicleCallback: _addVehicle),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You can only add up to 5 vehicles.'),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}
