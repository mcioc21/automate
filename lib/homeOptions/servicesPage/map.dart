import 'package:automate/app_theme.dart';
import 'package:automate/homeOptions/classes/workshop.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final String category;

  const MapPage({super.key, required this.category});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController? mapController;
  Set<Marker> _markers = {};
  bool _mapLoading = true;
  Workshop? _selectedWorkshop;

  final LatLng _center = const LatLng(44.43111, 26.10083); // Coordinates of Bucharest

  @override
  void initState() {
    super.initState();
    _loadAndSetMarkers();
  }

  void _loadAndSetMarkers() async {
    final workshops = await loadWorkshops(widget.category); // Load workshops based on the category
    setState(() {
      _markers.clear(); // Clear existing markers
      for (Workshop workshop in workshops) {
        _markers.add(
          Marker(
            markerId: MarkerId(workshop.id.toString()),
            position: LatLng(workshop.latitude, workshop.longitude),
            infoWindow: InfoWindow(
              title: workshop.name,
              snippet: workshop.description,
            ),
            onTap: () {
              setState(() {
                _selectedWorkshop = workshop; // Set selected workshop
              });
            },
            icon: BitmapDescriptor.defaultMarker, // Customize marker icon if needed
          ),
        );
      }
      _mapLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workshops Map"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            markers: _markers,
            onMapCreated: _onMapCreated,
            zoomControlsEnabled: true,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 12.0,
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.snow,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _selectedWorkshop != null ? workshopDetails() : promptToSelect(),
              ),
            ),
          ),
          if (_mapLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget workshopDetails() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_selectedWorkshop!.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(_selectedWorkshop!.address),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Implement navigation to see more details or booking
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(36),
          ),
          child: const Text("See more"),
        ),
      ],
    );
  }

  Widget promptToSelect() {
    return const Center(
      child: Text(
        "Tap any marker to see more",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}
