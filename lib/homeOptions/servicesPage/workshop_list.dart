import 'package:automate/homeOptions/servicesPage/details_workshop.dart';
import 'package:flutter/material.dart';
import 'package:automate/homeOptions/classes/workshop.dart';

class WorkshopListPage extends StatefulWidget {
  final String category;
  final Future<List<Workshop>> workshopsFuture;

  const WorkshopListPage({
    super.key,
    required this.category,
    required this.workshopsFuture,
  });

  @override
  _WorkshopListPageState createState() => _WorkshopListPageState();
}

class _WorkshopListPageState extends State<WorkshopListPage> {
  late Future<List<Workshop>> _workshopsFuture;

  @override
  void initState() {
    super.initState();
    _workshopsFuture = widget.workshopsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.category} Workshops"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<List<Workshop>>(
        future: _workshopsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return WorkshopListView(workshops: snapshot.data!);
          } else {
            return const Center(child: Text('No workshops found.'));
          }
        },
      ),
    );
  }
}

class WorkshopListView extends StatelessWidget {
  final List<Workshop> workshops;

  const WorkshopListView({super.key, required this.workshops});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: workshops.length,
      itemBuilder: (context, index) {
        Workshop workshop = workshops[index];
        return WorkshopTile(workshop: workshop);
      },
    );
  }
}

class WorkshopTile extends StatelessWidget {
  final Workshop workshop;

  const WorkshopTile({super.key, required this.workshop});

  @override
  Widget build(BuildContext context) {
    return InkWell( // Use InkWell or GestureDetector to handle taps
      onTap: () {
        // Navigate to the DetailsWorkshopPage when this tile is tapped
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailsWorkshopPage(workshop: workshop),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 140,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(workshop.photo),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(workshop.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(workshop.description, style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            workshop.address.isNotEmpty ? workshop.address : "No address provided",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
