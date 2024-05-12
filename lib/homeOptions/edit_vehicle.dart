import 'package:flutter/material.dart';

class EditVehiclePage extends StatefulWidget {
  final String name;
  final String vinNumber;
  final void Function(String name, String vinNumber) editVehicleCallback;

  const EditVehiclePage({
    super.key,
    required this.name,
    required this.vinNumber,
    required this.editVehicleCallback,
  });

  @override
  _EditVehiclePageState createState() => _EditVehiclePageState();
}

class _EditVehiclePageState extends State<EditVehiclePage> {
  late TextEditingController _nameController;
  late TextEditingController _vinController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _vinController = TextEditingController(text: widget.vinNumber);
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
      widget.editVehicleCallback(name, vinNumber);
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
        title: const Text('Edit Vehicle'),
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
