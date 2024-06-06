import 'package:automate/app_theme.dart';
import 'package:automate/homeOptions/classes/appointment.dart';
import 'package:automate/homeOptions/classes/vehicle.dart';
import 'package:automate/homeOptions/classes/workshop.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ViewAppointmentsPage extends StatelessWidget {
  const ViewAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Appointments'),
      ),
      body: FutureBuilder<List<Appointment>>(
        future: fetchAppointments(), // Implement this function to fetch appointments from Firestore
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Appointment> appointments = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
             child:
            ListView.builder(
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
}

class AppointmentTile extends StatelessWidget {
  final Appointment appointment;

  const AppointmentTile({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.grey[400],
      textColor: AppColors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), ),
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
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: AppColors.blue),
                                ),
                                TextSpan(
                                  text: snapshot.data,  // Assuming snapshot.data contains the vehicle name
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.blue),
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
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: AppColors.blue),
                  ),
                  TextSpan(
                    text: DateFormat('dd-MM-yyyy HH:mm').format(appointment.dateTime),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.blue),
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
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: AppColors.blue),
                                ),
                                TextSpan(
                                  text: snapshot.data,  // Assuming snapshot.data contains the vehicle name
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.blue),
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
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: AppColors.blue),
                  ),
                  TextSpan(
                    text: getAppointmentStatus(appointment), // Assuming this function returns the status of the appointment
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.blue),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
      trailing: ElevatedButton(
        onPressed: () {
          // Navigate to view/modify appointment page
          // You can implement this navigation logic here
        },
        child: const Text('Details'),
      ),
    );
  }

  String getAppointmentStatus(Appointment appointment) {
    // Implement your logic to determine appointment status
    // For now, let's return 'Confirmed' if vehicleId is not null, otherwise 'Not Confirmed'
    return appointment.vehicleId != null ? 'Confirmed' : 'Not Confirmed';
  }
}

Future<List<Appointment>> fetchAppointments() async {
  try {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DateTime today = DateTime.now();
      DateTime todayAtNine = DateTime(today.year, today.month, today.day, 8);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('userId', isEqualTo: user.uid)
          .where('dateTime', isGreaterThanOrEqualTo: todayAtNine)
          .get();
      // Map each document to an Appointment object
      List<Appointment> appointments = querySnapshot.docs.map((doc) => Appointment.fromSnapshot(doc)).toList();
      return appointments;
    } else {
      // No user signed in
      return []; // Return an empty list
    }
  } catch (e) {
    return []; // Return an empty list in case of an error
  }
}
