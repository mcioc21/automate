import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:automate/homeOptions/classes/workshop.dart';
import 'package:automate/homeOptions/classes/appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookAppointmentPage extends StatefulWidget {
  final Workshop workshop;

  const BookAppointmentPage({super.key, required this.workshop});

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _selectTime(context, picked);  // Proceed to select time after date
    }
  }

  void _selectTime(BuildContext context, DateTime date) async {
    var availableTimes = await getAvailableTimeSlots(widget.workshop.id, date);
    if (availableTimes.isNotEmpty) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(availableTimes.first),
     );

      if (pickedTime != null) {
        setState(() {
          _selectedTime = pickedTime;
          _selectedDate = DateTime(
            _selectedDate!.year,
            _selectedDate!.month,
            _selectedDate!.day,
            _selectedTime!.hour,
            _selectedTime!.minute,
          );
        });
      }
    }
  }

  Future<void> _saveAppointment() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please select a date and time first."),
        backgroundColor: Colors.red,
      ));
      return;
    }
    User? user = FirebaseAuth.instance.currentUser;

    // Create an appointment instance
    Appointment newAppointment = Appointment(
      uid: FirebaseFirestore.instance.collection('appointments').doc().id, // Generate a new document ID
      dateTime: _selectedDate!,
      description: "Appointment for ${widget.workshop.name}",
      userId: user!.uid,
      workshopId: widget.workshop.id.toString(),  // Store workshopId as a string if necessary
    );

    // Save to Firestore
    await FirebaseFirestore.instance.collection('appointments').doc(newAppointment.uid).set(newAppointment.toMap())
    .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Appointment booked successfully!"),
        backgroundColor: Colors.green,
      ));
    })
    .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to book appointment: $error"),
        backgroundColor: Colors.red,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book an Appointment with ${widget.workshop.name}"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select Date and Time'),
            ),
            if (_selectedDate != null)
              Text('Selected: ${_selectedDate!.toIso8601String()}'),
            ElevatedButton(
              onPressed: _saveAppointment,
              child: const Text('Confirm Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}
