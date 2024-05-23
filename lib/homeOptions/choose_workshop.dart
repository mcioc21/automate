import 'package:automate/colors.dart';
import 'package:flutter/material.dart';

class ChooseWorkshopPage extends StatelessWidget {
  const ChooseWorkshopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workshop Category"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Pick a category:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          // const Padding(
          //   padding: EdgeInsets.all(16.0),
          //   child: Text("Pick a category:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          // ),
          WorkshopButton(
            title: "Repair Shop",
            description: "General service shops for all types of repair.",
            onPressed: () {
              // Handle navigation or action for Repair Shop
            },
          ),
          WorkshopButton(
            title: "Detailing",
            description: "Specialized in detailing and cosmetic services.",
            onPressed: () {
              // Handle navigation or action for Detailing Shop
            },
          ),
          WorkshopButton(
            title: "Tyre Shop",
            description: "Focused on tyres and wheel services.",
            onPressed: () {
              // Handle navigation or action for Tyre Shop
            },
          ),
        ],
      ),
    );
  }
}

class WorkshopButton extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onPressed;

  const WorkshopButton({
    super.key,
    required this.title,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.snow, backgroundColor: AppColors.blue, // Text color
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(description, style: const TextStyle(fontSize: 14, color: Colors.amber)),
          ],
        ),
      ),
    );
  }
}
