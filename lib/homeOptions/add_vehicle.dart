import 'package:flutter/material.dart';

class AddVehiclePage extends StatefulWidget {
  final void Function(String name, String vinNumber) addVehicleCallback;

  const AddVehiclePage({super.key, required this.addVehicleCallback});

  @override
  _AddVehiclePageState createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  late TextEditingController _nameController;
  late TextEditingController _vinController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _vinController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _vinController.dispose();
    super.dispose();
  }

  void _saveVehicle() {
    final name = _nameController.text.trim();
    final vinNumber = _vinController.text.trim();

    if (name.isNotEmpty && vinNumber.isNotEmpty) {
      widget.addVehicleCallback(name, vinNumber); // Call the callback function
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both name and VIN number.'),
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
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _vinController,
              decoration: const InputDecoration(labelText: 'VIN Number'),
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
