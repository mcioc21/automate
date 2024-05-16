import 'dart:convert';
import 'package:automate/homeOptions/vehicleOptions/fuel_type.dart';
import 'package:automate/otherWidgets/create_account_banner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'vehicle.dart';
import 'add_vehicle.dart';
import 'edit_vehicle.dart';

class GaragePage extends StatefulWidget {
  final User? user;

  const GaragePage({super.key, this.user});

  @override
  _GaragePageState createState() => _GaragePageState();
}

class _GaragePageState extends State<GaragePage> {
  List<Vehicle> _vehicles = [];
  bool _isLoading = true;
  late bool _isWarningVisible;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    setState(() {
      _isLoading = true;
    });
    if (widget.user != null) {
      var collection = _firestore.collection('users').doc(widget.user!.uid).collection('vehicles');
      var snapshot = await collection.get();
      var vehicles = snapshot.docs.map((doc) => Vehicle.fromMap(doc.data() as Map<String, dynamic>..putIfAbsent('uid', () => doc.id))).toList();
      setState(() {
        _vehicles = vehicles;
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
        });
      }
      setState(() {
        _isWarningVisible = true;
        _isLoading = false;
      });
    }
  }

  void _addVehicle(String make, String model, FuelType fuelType, String vinNumber) {
    if (widget.user != null) {
      var collection = _firestore.collection('users').doc(widget.user!.uid).collection('vehicles');
      collection.add({'make': make, 'model': model, 'fuelType': fuelType.name, 'vinNumber': vinNumber}).then((docRef) {
        setState(() {
          _vehicles.add(Vehicle(uid: docRef.id, make: make, model: model, fuelType: fuelType, vinNumber: vinNumber));
        });
      });
    } else {
      setState(() {
        _vehicles.add(Vehicle(make: make, model: model, fuelType: fuelType, vinNumber: vinNumber));
        _saveVehicles();
      });
    }
  }

  void _removeVehicle(int index) {
    if (widget.user != null) {
      var docRef = _firestore.collection('users').doc(widget.user!.uid).collection('vehicles').doc(_vehicles[index].uid);
      docRef.delete().then((_) {
        setState(() {
          _vehicles.removeAt(index);
        });
      });
    } else {
      setState(() {
        _vehicles.removeAt(index);
        _saveVehicles();
      });
    }
  }

  Future<void> _saveVehicles() async {
    if (widget.user == null) {
      final prefs = await SharedPreferences.getInstance();
      final String vehiclesString = jsonEncode(Vehicle.toMapList(_vehicles));
      await prefs.setString('vehicles', vehiclesString);
    }
  }

  void _editVehicle(int index, String make, String model, FuelType fuelType, String vinNumber) {
    if (widget.user != null) {
      var docRef = _firestore.collection('users').doc(widget.user!.uid).collection('vehicles').doc(_vehicles[index].uid);
      docRef.update({'make': make, 'model': model, 'fuelType': fuelType.name, 'vinNumber': vinNumber}).then((_) {
        setState(() {
          _vehicles[index] = Vehicle(uid: _vehicles[index].uid, make: make, model: model, fuelType: fuelType, vinNumber: vinNumber);
        });
      });
    } else {
      setState(() {
        _vehicles[index] = Vehicle(make: make, model: model, fuelType: fuelType, vinNumber: vinNumber);
        _saveVehicles();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                widget.user == null && _isWarningVisible ? const AccountWarningBanner() : Container(),
                Expanded(
                  child: _vehicles.isEmpty
                      ? const Center(child: Text('Add your first vehicle'))
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
                                        editVehicleCallback: (make, model, fuelType, vin) {
                                          _editVehicle(index, make, model, fuelType, vin);
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
                                            vehicle.make,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddVehiclePage(addVehicleCallback: _addVehicle),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
