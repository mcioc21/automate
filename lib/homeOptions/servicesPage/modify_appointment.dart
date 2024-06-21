import 'package:automate/baseFiles/app_theme.dart';
import 'package:automate/baseFiles/classes/vehicle.dart';
import 'package:automate/baseFiles/classes/workshop.dart';
import 'package:flutter/material.dart';
import 'package:automate/baseFiles/classes/appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:automate/baseFiles/user_provider.dart';

class ModifyAppointmentPage extends StatefulWidget {
  final Appointment appointment;

  const ModifyAppointmentPage({super.key, required this.appointment});

  @override
  _ModifyAppointmentPageState createState() => _ModifyAppointmentPageState();
}

class _ModifyAppointmentPageState extends State<ModifyAppointmentPage> {
  String? vehicleName;
  String? workshopName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVehicleAndWorkshopDetails();
  }

  void fetchVehicleAndWorkshopDetails() async {
    vehicleName = await getVehicleNameByUid(widget.appointment.vehicleId ?? '');
    workshopName =
        await getWorkshopNameById(int.parse(widget.appointment.workshopId));
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modify Appointment'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                        leading: const Icon(Icons.event_note),
                        title: const Text("Your appointment",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          'On ${DateFormat('yyyy-MM-dd – kk:mm').format(widget.appointment.dateTime)}',
                          style: const TextStyle(fontSize: 20),
                        )),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text('Workshop: $workshopName',
                          style: const TextStyle(fontSize: 20)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.car_repair),
                      title: Text('Vehicle: $vehicleName',
                          style: const TextStyle(fontSize: 20)),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(
                                MediaQuery.of(context).size.width * 0.8, 40)),
                            backgroundColor:
                                MaterialStateProperty.all(AppColors.teal),
                            foregroundColor:
                                MaterialStateProperty.all(AppColors.snow),
                          ),
                          child: const Text('RESCHEDULE',
                              style: TextStyle(fontSize: 18)),
                          onPressed: () {
                            rescheduleAppointment(context, widget.appointment);
                          },
                        ),
                        const SizedBox(height: 5),
                        TextButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(
                                MediaQuery.of(context).size.width * 0.8, 40)),
                            backgroundColor:
                                MaterialStateProperty.all(AppColors.blue),
                            foregroundColor:
                                MaterialStateProperty.all(AppColors.snow),
                          ),
                          child: const Text('CANCEL',
                              style: TextStyle(fontSize: 18)),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  title: const Text("Confirm Cancellation"),
                                  content: const Text(
                                      "Are you sure you want to cancel this booking?",
                                      style: TextStyle(fontSize: 16)),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(dialogContext)
                                            .pop(); // Close the dialog
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("Confirm"),
                                      onPressed: () {
                                        // Proceed with cancelling the appointment
                                        Navigator.of(dialogContext)
                                            .pop(); // Close the dialog first
                                        cancelAppointment(
                                            context, widget.appointment);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> rescheduleAppointment(
      BuildContext context, Appointment appointment) async {
    DateTime? newDateTime = await showDatePicker(
      context: context,
      initialDate: appointment.dateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (newDateTime != null) {
      List<DateTime> availableTimes = await getAvailableTimeSlots(
          int.parse(appointment.workshopId), newDateTime);

      List<TimeOfDay> timeOptions = availableTimes
          .map((dateTime) =>
              TimeOfDay(hour: dateTime.hour, minute: dateTime.minute))
          .toList();

      if (timeOptions.isEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'No Available Times',
              textAlign: TextAlign.center,
            ),
            content: const Text(
                'There are no available times for this date. Please choose another date.',
                textAlign: TextAlign.center),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      DateTime? selectedDateTime;

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Select a Time"),
            content: SizedBox(
              width: double.minPositive,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: timeOptions.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(timeOptions[index].format(context)),
                    onTap: () {
                      Navigator.of(context).pop();
                      selectedDateTime = DateTime(
                        newDateTime.year,
                        newDateTime.month,
                        newDateTime.day,
                        timeOptions[index].hour,
                        timeOptions[index].minute,
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      );

      if (selectedDateTime != null) {
        // Update the Firestore document
        await FirebaseFirestore.instance
            .collection('appointments')
            .doc(appointment.uid)
            .update({'dateTime': Timestamp.fromDate(selectedDateTime!)});

        // Inform the user
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Appointment rescheduled to ${DateFormat('yyyy-MM-dd – kk:mm').format(selectedDateTime!)}')));

        // Update global appointment count if needed
        Provider.of<UserProvider>(context, listen: false)
            .fetchTodayAppointmentsCount();

        // Navigate back or refresh the page
        Navigator.pop(context);
      } else {
        // Inform the user that no time was selected
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("No time selected. Appointment not rescheduled.")));
      }
    }
  }

  void cancelAppointment(BuildContext context, Appointment appointment) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointment.uid)
          .delete();
      Provider.of<UserProvider>(context, listen: false)
          .fetchTodayAppointmentsCount();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Appointment cancelled successfully")));
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to cancel appointment")));
    }
  }
}
