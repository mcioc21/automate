import 'package:flutter/material.dart';
import 'package:automate/homeOptions/vehicleOptions/fuel_type.dart'; // Ensure this import is correct

class EditVehiclePage extends StatefulWidget {
  final String make;
  final String model;
  final FuelType fuelType;
  final String vinNumber;
  final void Function(String make, String model, FuelType fuelType, String vinNumber) editVehicleCallback;

  const EditVehiclePage({
    super.key,
    required this.make,
    required this.model,
    required this.fuelType,
    required this.vinNumber,
    required this.editVehicleCallback,
  });

  @override
  _EditVehiclePageState createState() => _EditVehiclePageState();
}

class _EditVehiclePageState extends State<EditVehiclePage> {
  late TextEditingController _makeController;
  late TextEditingController _modelController;
  late TextEditingController _vinController;
  FuelType? _selectedFuelType;

  @override
  void initState() {
    super.initState();
    _makeController = TextEditingController(text: widget.make);
    _modelController = TextEditingController(text: widget.model);
    _vinController = TextEditingController(text: widget.vinNumber);
    _selectedFuelType = widget.fuelType; // Initialize with the provided fuel type
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _vinController.dispose();
    super.dispose();
  }

  void _saveVehicle() {
    if (_makeController.text.isNotEmpty && _modelController.text.isNotEmpty && _vinController.text.isNotEmpty && _selectedFuelType != null) {
      widget.editVehicleCallback(
        _makeController.text.trim(),
        _modelController.text.trim(),
        _selectedFuelType!,
        _vinController.text.trim(),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Vehicle'),
      ),
      body: SingleChildScrollView(
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
            const SizedBox(height: 16.0),
            DropdownButton<FuelType>(
              value: _selectedFuelType,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              onChanged: (FuelType? newValue) {
                setState(() {
                  _selectedFuelType = newValue;
                });
              },
              items: FuelType.values.map<DropdownMenuItem<FuelType>>((FuelType value) {
                return DropdownMenuItem<FuelType>(
                  value: value,
                  child: Text(value.name),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveVehicle,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
