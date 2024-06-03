import 'package:flutter/material.dart';
import 'package:automate/homeOptions/classes/workshop.dart';

class WorkshopListPage extends StatelessWidget {
  final String category;

  const WorkshopListPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$category Workshops"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<List<Workshop>>(
        future: loadWorkshops(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Workshop workshop = snapshot.data![index];
                return WorkshopTile(workshop: workshop);
              },
            );
          } else {
            return const Center(child: Text('No workshops found.'));
          }
        },
      ),
    );
  }
}

class WorkshopTile extends StatelessWidget {
  final Workshop workshop;

  const WorkshopTile({super.key, required this.workshop});

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
