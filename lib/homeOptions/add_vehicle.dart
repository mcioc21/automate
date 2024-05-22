import 'package:flutter/material.dart';
import 'package:automate/homeOptions/vehicleOptions/fuel_type.dart';

class AddVehiclePage extends StatefulWidget {
  final void Function(String make, String model, FuelType fuelType,
      String vinNumber, bool isDefault) addVehicleCallback;
  final bool
      isFirstVehicle; // New parameter to indicate if this is the first vehicle being added

  const AddVehiclePage(
      {super.key,
      required this.addVehicleCallback,
      this.isFirstVehicle = false});

  @override
  _AddVehiclePageState createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  late TextEditingController _makeController;
  late TextEditingController _modelController;
  late TextEditingController _vinController;
  FuelType? _selectedFuelType =
      FuelType.Petrol; // Default to Petrol or any other default
  late bool _isDefault; // Manage the state of default vehicle checkbox

  @override
  void initState() {
    super.initState();
    _makeController = TextEditingController();
    _modelController = TextEditingController();
    _vinController = TextEditingController();
    _isDefault = widget.isFirstVehicle; // Set to true if it's the first vehicle
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _vinController.dispose();
    super.dispose();
  }

  void _saveVehicle() {
    final make = _makeController.text.trim();
    final model = _modelController.text.trim();
    final vinNumber = _vinController.text.trim();
    if (make.isNotEmpty &&
        model.isNotEmpty &&
        vinNumber.isNotEmpty &&
        _selectedFuelType != null) {
      widget.addVehicleCallback(
          make, model, _selectedFuelType!, vinNumber, _isDefault);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter all fields and select a fuel type.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vehicle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _makeController,
              decoration: const InputDecoration(labelText: 'Make'),
            ),
            TextField(
              controller: _modelController,
              decoration: const InputDecoration(labelText: 'Model'),
            ),
            TextField(
              controller: _vinController,
              decoration: const InputDecoration(labelText: 'VIN Number'),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Fuel Type', style: TextStyle(fontSize: 16)),
                DropdownButton<FuelType>(
                  value: _selectedFuelType,
                  padding: const EdgeInsets.only(right: 8),
                  borderRadius: BorderRadius.circular(8),
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  onChanged: (FuelType? newValue) {
                    setState(() {
                      _selectedFuelType = newValue;
                    });
                  },
                  items: FuelType.values
                      .map<DropdownMenuItem<FuelType>>((FuelType value) {
                    return DropdownMenuItem<FuelType>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                if (!widget.isFirstVehicle) {
                  // Only allow toggling if it's not the first vehicle
                  setState(() {
                    _isDefault =
                        !_isDefault; // Toggle the default status on tap
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _isDefault,
                    onChanged: widget.isFirstVehicle
                        ? null
                        : (bool? value) {
                            setState(() {
                              _isDefault = value ?? _isDefault;
                            });
                          },
                  ),
                  const Text('Make this the default vehicle?'),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _saveVehicle,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
