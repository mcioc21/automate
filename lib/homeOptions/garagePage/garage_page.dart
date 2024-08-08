import 'dart:convert';
import 'package:automate/homeOptions/vehicleOptions/fuel_type.dart';
import 'package:automate/otherWidgets/create_account_banner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../baseFiles/classes/vehicle.dart';
import 'add_vehicle.dart';
import 'edit_vehicle.dart';
import 'package:automate/baseFiles/user_provider.dart';

class GaragePage extends StatefulWidget {
  const GaragePage({super.key});

  @override
  _GaragePageState createState() => _GaragePageState();
}

class _GaragePageState extends State<GaragePage> {
  List<Vehicle> _vehicles = [];
  bool _isLoading = true;
  late bool _isWarningVisible;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserProvider? _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _loadVehicles();
    _userProvider!.addListener(_onUserChange);
  }

  @override
  void dispose() {
    _userProvider!.removeListener(_onUserChange);
    super.dispose();
  }

  void _onUserChange() {
    if (_userProvider!.user == null) {
      // User has logged out, clear the vehicles
      setState(() {
        _vehicles = [];
        _isWarningVisible = true;
      });
    } else {
      // User has logged in, load the vehicles
      _loadVehicles();
    }
  }

  Future<void> _loadVehicles() async {
    setState(() {
      _isLoading = true;
    });

    final user = _userProvider!.user;

    if (user != null) {
      var collection = _firestore.collection('users').doc(user.uid).collection('vehicles');
      var snapshot = await collection.get();
      var vehicles = snapshot.docs.map((doc) => Vehicle.fromMap(doc.data()..putIfAbsent('uid', () => doc.id))).toList();
      setState(() {
        _vehicles = vehicles;
        _userProvider!.updateVehicles(_vehicles); // Notify UserProvider about the updated vehicles
        _isLoading = false;
        _isWarningVisible = false;
      });
      
    } else {
      final prefs = await SharedPreferences.getInstance();
      final String? vehiclesString = prefs.getString('vehicles');
      if (vehiclesString != null) {
        final List<dynamic> vehiclesList = jsonDecode(vehiclesString);
        setState(() {
        _vehicles = Vehicle.fromMapList(vehiclesList);
        _isLoading = false;
        _isWarningVisible = true;
      });
      }
    }
  }

  void _addVehicle(String make, String model, FuelType fuelType, String vinNumber, bool isDefault) async {
  final user = _userProvider!.user;

  if (user != null) {
    var collection = _firestore.collection('users').doc(user.uid).collection('vehicles');
    if (isDefault) {
      // First, ensure no other vehicle is set as default
      var snapshot = await collection.where('isDefault', isEqualTo: true).get();
      for (var doc in snapshot.docs) {
        await doc.reference.update({'isDefault': false});
      }
    }
    
    // Then add the new vehicle
    await collection.add({
      'make': make,
      'model': model,
      'fuelType': fuelType.name,
      'vinNumber': vinNumber,
      'isDefault': isDefault
    }).then((value) => _vehicles.add(Vehicle(make: make, model: model, fuelType: fuelType, vinNumber: vinNumber, isDefault: isDefault)));
    _loadVehicles();

  } else {
    // Handle non-authenticated user case
    setState(() {
      _vehicles.add(Vehicle(make: make, model: model, fuelType: fuelType, vinNumber: vinNumber, isDefault: isDefault));
      _saveVehicles();
      setState(() {});
    });
  }
}

void _removeVehicle(int index) async {
  final user = _userProvider!.user;
  if (user == null) {
    // For non-authenticated users, manage locally only
    setState(() {
      _vehicles.removeAt(index);
      _saveVehicles();
    });
    return;
  }

  var docRef = _firestore.collection('users').doc(user.uid).collection('vehicles').doc(_vehicles[index].uid);
  try {
    var removedVehicle = _vehicles.removeAt(index);
    await docRef.delete();

    Vehicle? newDefaultVehicle;

    // Check if the removed vehicle was the default and if so, assign a new default
    if (removedVehicle.isDefault && _vehicles.isNotEmpty) {
      newDefaultVehicle = _vehicles.first;
      await _firestore.collection('users').doc(user.uid).collection('vehicles').doc(newDefaultVehicle.uid).update({'isDefault': true});
      // Update the default vehicle in the UserProvider
      _userProvider!.updateDefaultVehicle(newDefaultVehicle);
    } else if (_vehicles.isEmpty) {
      _userProvider!.updateDefaultVehicle(null);  // No vehicles left, set default to null
    }

    setState(() {});

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to remove vehicle: $e")));
  }
}

  Future<void> _saveVehicles() async {
    final user = _userProvider!.user;

    if (user == null) {
      final prefs = await SharedPreferences.getInstance();
      final String vehiclesString = jsonEncode(Vehicle.toMapList(_vehicles));
      await prefs.setString('vehicles', vehiclesString);
    }
  }

  void _editVehicle(int index, String make, String model, FuelType fuelType, String vinNumber, bool isDefault) async {
    final user = _userProvider!.user;

    if (user != null) {
      var docRef = _firestore.collection('users').doc(user.uid).collection('vehicles').doc(_vehicles[index].uid);

      if (isDefault) {
        // Unset all other defaults first if this vehicle is to be set as default
        var collection = _firestore.collection('users').doc(user.uid).collection('vehicles');
        var snapshot = await collection.get();
        var vehicles = snapshot.docs.map((doc) => Vehicle.fromMap(doc.data()..putIfAbsent('uid', () => doc.id))).toList();

        List<Future> updates = vehicles.where((v) => v.isDefault).map((vehicle) {
          return collection.doc(vehicle.uid).update({'isDefault': false});
        }).toList();

        await Future.wait(updates); // Ensure all updates complete before proceeding

        setState(() {
            for (var v in vehicles) {
              v.isDefault = false; // Update local list state
            }
            _vehicles = vehicles;
          });
      }
      await docRef.update({
          'make': make,
          'model': model,
          'fuelType': fuelType.name,
          'vinNumber': vinNumber,
          'isDefault': isDefault
        });

      // Update local state
      setState(() {
        _vehicles[index] = Vehicle(uid: _vehicles[index].uid, make: make, model: model, fuelType: fuelType, vinNumber: vinNumber, isDefault: isDefault);
      });

    } else {
      // Handle local storage for non-authenticated users
      setState(() {
        if (isDefault) {
          // Make sure only one default vehicle exists
          for (var v in _vehicles) {
            v.isDefault = false;
          }
        }
        _vehicles[index] = Vehicle(make: make, model: model, fuelType: fuelType, vinNumber: vinNumber, isDefault: isDefault);
        _saveVehicles();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _userProvider!.user;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                user == null && _isWarningVisible ? const AccountWarningBanner() : Container(),
                const SizedBox(height: 10),
                Expanded(
                  child: _vehicles.isEmpty
                      ? const Center(child: Text('Press the blue button to add your first vehicle'))
                      : ListView.builder(
                          itemCount: _vehicles.length,
                          itemBuilder: (context, index) {
                            final vehicle = _vehicles[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditVehiclePage(
                                        make: vehicle.make,
                                        model: vehicle.model,
                                        fuelType: vehicle.fuelType,
                                        vinNumber: vehicle.vinNumber,
                                        isDefault: vehicle.isDefault,
                                        editVehicleCallback: (make, model, fuelType, vin, isDefault) {
                                          _editVehicle(index, make, model, fuelType, vin, isDefault);
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 20),
                                          Text(
                                            '${vehicle.make} ${vehicle.model}',
                                            style: const TextStyle(fontSize: 18.0),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () => _removeVehicle(index),
                                            child: Container(
                                              width: 40,
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
                                          const SizedBox(width: 20),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: _vehicles.length < 5
          ? FloatingActionButton(
              onPressed: () {
                print(_vehicles);
                // Navigate to the AddVehiclePage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddVehiclePage(addVehicleCallback: _addVehicle, isFirstVehicle: _vehicles.isEmpty),
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
