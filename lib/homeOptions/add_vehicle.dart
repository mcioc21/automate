import 'package:flutter/material.dart';
import 'package:automate/homeOptions/vehicleOptions/fuel_type.dart'; // Assuming you have FuelType defined here

class AddVehiclePage extends StatefulWidget {
  final void Function(String make, String model, FuelType fuelType, String vinNumber) addVehicleCallback;

  const AddVehiclePage({super.key, required this.addVehicleCallback});

  @override
  _AddVehiclePageState createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  late TextEditingController _makeController;
  late TextEditingController _modelController;
  late TextEditingController _vinController;
  FuelType? _selectedFuelType = FuelType.Petrol; // Default to Petrol or any other default

  @override
  void initState() {
    super.initState();
    _makeController = TextEditingController();
    _modelController = TextEditingController();
    _vinController = TextEditingController();
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
    if (make.isNotEmpty && model.isNotEmpty && vinNumber.isNotEmpty && _selectedFuelType != null) {
      widget.addVehicleCallback(make, model, _selectedFuelType!, vinNumber);
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
            DropdownButton<FuelType>(
              value: _selectedFuelType,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
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
