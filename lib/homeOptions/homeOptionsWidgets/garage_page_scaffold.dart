import 'package:automate/homeOptions/edit_vehicle.dart';
import 'package:automate/homeOptions/vehicle.dart';
import 'package:automate/homeOptions/vehicleOptions/fuel_type.dart';
import 'package:flutter/material.dart';
import 'package:automate/otherWidgets/create_account_banner.dart';

class GaragePageScaffold extends StatelessWidget {
  final List<Vehicle> vehicles;
  final bool isLoading;
  final bool isWarningVisible;
  final Function addVehicleCallback;
  final Function(int) removeVehicleCallback;
  final Function(int, String, String, FuelType, String, bool) editVehicleCallback;

  const GaragePageScaffold({
    super.key,
    required this.vehicles,
    required this.isLoading,
    required this.isWarningVisible,
    required this.addVehicleCallback,
    required this.removeVehicleCallback,
    required this.editVehicleCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (isWarningVisible) const AccountWarningBanner(),
                Expanded(
                  child: vehicles.isEmpty
                      ? const Center(child: Text('Add your first vehicle'))
                      : ListView.builder(
                          itemCount: vehicles.length,
                          itemBuilder: (context, index) {
                            final vehicle = vehicles[index];
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditVehiclePage(
                                    make: vehicle.make,
                                    model: vehicle.model,
                                    fuelType: vehicle.fuelType,
                                    vinNumber: vehicle.vinNumber,
                                    isDefault: vehicle.isDefault,
                                    editVehicleCallback: (make, model, fuelType, vin, isDefault) =>
                                        editVehicleCallback(index, make, model, fuelType, vin, isDefault),
                                  ),
                                ),
                              ),
                              child: VehicleTile(vehicle: vehicle, removeVehicle: () => removeVehicleCallback(index)),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: vehicles.length < 5
          ? FloatingActionButton(
              onPressed: () => addVehicleCallback(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class VehicleTile extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback removeVehicle;

  const VehicleTile({
    super.key,
    required this.vehicle,
    required this.removeVehicle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(vehicle.make),
      subtitle: Text(vehicle.model),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: removeVehicle,
      ),
    );
  }
}
