import 'package:automate/baseFiles/app_theme.dart';
import 'package:automate/baseFiles/classes/appointment.dart';
import 'package:automate/baseFiles/classes/vehicle.dart';
import 'package:automate/baseFiles/classes/workshop.dart';
import 'package:automate/homeOptions/servicesPage/modify_appointment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ViewAppointmentsPage extends StatefulWidget {
  const ViewAppointmentsPage({super.key});

  @override
  _ViewAppointmentsPageState createState() => _ViewAppointmentsPageState();
}

class _ViewAppointmentsPageState extends State<ViewAppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Appointments'),
      ),
      body: StreamBuilder<List<Appointment>>(
        stream: fetchAppointmentsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No appointments yet.\nGo to \"Book an Appointment\" to create one.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            );
          } else {
            List<Appointment> appointments = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  return AppointmentTile(appointment: appointments[index]);
                },
              ),
            );
          }
        },
      ),
    );
  }

  Stream<List<Appointment>> fetchAppointmentsStream() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DateTime today = DateTime.now();
      DateTime todayAtNine = DateTime(today.year, today.month, today.day, 8);
      return FirebaseFirestore.instance
          .collection('appointments')
          .where('userId', isEqualTo: user.uid)
          .where('dateTime', isGreaterThanOrEqualTo: todayAtNine)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => Appointment.fromSnapshot(doc)).toList());
    } else {
      return const Stream.empty(); // Return an empty stream if user is not logged in
    }
  }
}

class AppointmentTile extends StatelessWidget {
  final Appointment appointment;

  const AppointmentTile({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        tileColor: Colors.grey[400],
        textColor: AppColors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: FutureBuilder<String>(
          future: getWorkshopNameById(int.parse(appointment.workshopId)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading Workshop...');
            } else if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Workshop: ',
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: AppColors.blue),
                      ),
                      TextSpan(
                        text: snapshot
                            .data, // Assuming snapshot.data contains the vehicle name
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.blue),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Text('Workshop: Unknown');
            }
          },
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Date & Time: ',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: AppColors.blue),
                  ),
                  TextSpan(
                    text: DateFormat('dd-MM-yyyy HH:mm')
                        .format(appointment.dateTime),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.blue),
                  ),
                ],
              ),
            ),
            FutureBuilder<String?>(
              future: getVehicleNameByUid(appointment.vehicleId ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading Vehicle...');
                } else if (snapshot.hasData && snapshot.data != null) {
                  return RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Vehicle: ',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: AppColors.blue),
                        ),
                        TextSpan(
                          text: snapshot
                              .data, // Assuming snapshot.data contains the vehicle name
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.blue),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Text('Vehicle: Not assigned');
                }
              },
            ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Status: ',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: AppColors.blue),
                  ),
                  TextSpan(
                    text: getAppointmentStatus(
                        appointment), // Assuming this function returns the status of the appointment
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.blue),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModifyAppointmentPage(appointment: appointment),
                  ),
          );
          },
          child: const Text('Details'),
        ),
      ),
    );
  }

  String getAppointmentStatus(Appointment appointment) {
    // Implement your logic to determine appointment status
    // For now, let's return 'Confirmed' if vehicleId is not null, otherwise 'Not Confirmed'
    return appointment.vehicleId != null ? 'Confirmed' : 'Not Confirmed';
  }
}

