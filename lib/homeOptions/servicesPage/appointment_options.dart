import 'package:automate/homeOptions/servicesPage/choose_appointment_category.dart';
import 'package:automate/homeOptions/servicesPage/view_appointments.dart';
import 'package:flutter/material.dart';
import 'package:automate/baseFiles/app_theme.dart'; // Assuming AppColors and app theme configurations are defined here

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointments",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppointmentButton(
              title: "Book an Appointment",
              description: "Schedule a new appointment for service or repair.",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChooseAppointmentCategory(),
                  ),
                );
              },
            ),
            AppointmentButton(
              title: "View Current Appointments",
              description: "Review all your upcoming and past appointments.",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewAppointmentsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentButton extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onPressed;

  const AppointmentButton({
    super.key,
    required this.title,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.snow,
          backgroundColor: AppColors.blue, // Text color
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max, // Use min to fit content
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(description, style: const TextStyle(fontSize: 12, color: Colors.amber)),
            )
          ],
        ),
      ),
    );
  }
}
