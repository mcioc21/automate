import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:automate/homeOptions/classes/workshop.dart';

class DetailsWorkshopPage extends StatelessWidget {
  final Workshop workshop;

  const DetailsWorkshopPage({super.key, required this.workshop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${workshop.name} Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(workshop.photo),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2, // Give more space to the details
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(workshop.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 40),
                        Text(workshop.description),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.grey[600]),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(workshop.address.isNotEmpty ? workshop.address : "No address provided", style: TextStyle(color: Colors.grey[600]),),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2, // Give more space to the map
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(workshop.latitude, workshop.longitude),
                      zoom: 12,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId(workshop.id.toString()),
                        position: LatLng(workshop.latitude, workshop.longitude),
                      ),
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to make an appointment page or trigger appointment logic
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), // Ensures the button is easily tappable
              ),
              child: const Text("Make an appointment to this workshop"),
            ),
          ),
        ],
      ),
    );
  }
}
