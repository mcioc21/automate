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

  final LatLng _center =
      const LatLng(44.43111, 26.10083); // Coordinates of Bucharest

  @override
  void initState() {
    super.initState();
    _loadAndSetMarkers();
  }

  void _loadAndSetMarkers() async {
    final workshops = await loadWorkshops(widget.category);
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
                _selectedWorkshop = workshop;
              });
            },
            icon: BitmapDescriptor
                .defaultMarker, // Customize marker icon if needed
          ),
        );
      }
    });
    setState(() {
      _mapLoading = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _mapLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workshops Map",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        leading: Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0), // Rounded corners
                child: SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.43, // Height of the map
                  width: MediaQuery.of(context).size.width *
                      0.95, // Width of the map
                  child: Stack(
                    children: [
                      GoogleMap(
                        markers: _markers,
                        zoomControlsEnabled: true,
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: _center,
                          zoom: 12.0,
                        ),
                      ),
                      (_mapLoading)
                          ? const Center(child: CircularProgressIndicator())
                          : Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _selectedWorkshop != null
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text("Name: ${_selectedWorkshop!.name}",
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold)),
                              // Text("Description: ${_selectedWorkshop!.description}",
                              //     style: const TextStyle(
                              //         fontSize: 15.0,
                              //         fontWeight: FontWeight.bold,
                              //         overflow: TextOverflow.ellipsis,
                              //         )
                              //         ),
                            ],
                          ),
                        ])
                      : const Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child:
                              Text("Click on a marker to see more details!"))),
            ],
          )
        ],
      ),
    );
  }
}
