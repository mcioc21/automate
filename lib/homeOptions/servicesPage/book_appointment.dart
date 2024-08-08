import 'package:automate/baseFiles/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:automate/baseFiles/classes/vehicle.dart';
import 'package:automate/baseFiles/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:automate/baseFiles/classes/workshop.dart';
import 'package:automate/baseFiles/classes/appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BookAppointmentPage extends StatefulWidget {
  final Workshop workshop;

  const BookAppointmentPage({super.key, required this.workshop});

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<Vehicle> _vehicles = []; // List to store user's vehicles
  Vehicle? _selectedVehicle; // Currently selected vehicle
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late UserProvider _userProvider;
  
  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _loadVehicles();
    _userProvider.addListener(_onUserChange);
  }

  void _loadVehicles() async {
    final user = _userProvider.user;
    var collection = _firestore.collection('users').doc(user?.uid).collection('vehicles');
    var snapshot = await collection.get();
    var vehicles = snapshot.docs.map((doc) => Vehicle.fromMap(doc.data()..putIfAbsent('uid', () => doc.id))).toList();
    setState(() {
      _vehicles = vehicles;
    });

  }

  @override
  void dispose() {
    _userProvider.removeListener(_onUserChange);
    super.dispose();
  }

  void _onUserChange() {
    _loadVehicles();
  }

  void _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    if (initialDate.weekday == 6) { // If it's Saturday, skip to Monday
      initialDate = initialDate.add(const Duration(days: 2));
    } else if (initialDate.weekday == 7) { // If it's Sunday, skip to Monday
      initialDate = initialDate.add(const Duration(days: 1));
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 1, DateTime.now().day),
      selectableDayPredicate: (DateTime date) {
        return date.weekday != 6 && date.weekday != 7; // Disable weekends
      },
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

    // Convert List<DateTime> to List<TimeOfDay>
    List<TimeOfDay> timeOptions = availableTimes
        .map((dateTime) => TimeOfDay(hour: dateTime.hour, minute: dateTime.minute))
        .toList();

    // No available times message
    if (timeOptions.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('No Available Times', textAlign: TextAlign.center,),
          content: const Text('There are no available times for this date. Please choose another date.', textAlign: TextAlign.center),
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

    // Show custom dialog with available times
    showDialog(
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
                    setState(() {
                      _selectedTime = timeOptions[index];
                      _selectedDate = DateTime(
                        _selectedDate!.year,
                        _selectedDate!.month,
                        _selectedDate!.day,
                        _selectedTime!.hour,
                        _selectedTime!.minute,
                      );
                    });
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveAppointment() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please select a date and time."),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (_selectedVehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please select a vehicle."),
        backgroundColor: Colors.red,
      ));
      return;
    }
    User? user = FirebaseAuth.instance.currentUser;

    // Create an appointment instance
    Appointment newAppointment = Appointment(
      uid: FirebaseFirestore.instance.collection('appointments').doc().id, // Generate a new document ID
      dateTime: _selectedDate!,
      description: "${user?.email}'s appointment for ${widget.workshop.name}",
      userId: user!.uid,
      workshopId: widget.workshop.id.toString(),  // Store workshopId as a string if necessary
      vehicleId: _selectedVehicle!.uid, // Add vehicleId to appointment
    );

    // Save to Firestore
    await FirebaseFirestore.instance.collection('appointments').doc(newAppointment.uid).set(newAppointment.toMap())
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Appointment booked successfully!"),
        backgroundColor: Colors.green,
      ));
        UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.fetchTodayAppointmentsCount(); // Update appointment count
        Navigator.of(context).popUntil((route) => route.isFirst); // Pop all routes until the first one
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
        title: Text("Appointment for ${widget.workshop.name}", style: const TextStyle(fontSize: 17),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Appointment details:", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Workshop:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(width: 10),
                Text(widget.workshop.name, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Vehicle:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(width: 10),
                _buildVehicleDropdown(),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Date & Time:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(width: 10),
                if (_selectedDate != null)
                  Text(DateFormat('dd MM yyyy HH:mm').format(_selectedDate!), style: const TextStyle(fontSize: 16),) // Display selected date and time
                else const Text("Not selected yet"),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Select Date and Time', style: TextStyle(fontSize: 13)),
                ),
                const SizedBox(width: 3),
                ElevatedButton(
                  onPressed: _saveAppointment,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(AppColors.teal),
                  ),
                  child: const Text('Confirm Appointment', style: TextStyle(fontSize: 13))
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleDropdown() {
  if (_vehicles.isEmpty) {
    return const Text('No vehicles found');
  } else {
    return DropdownButton<String>(
      value: _selectedVehicle?.uid,
      onChanged: (value) {
        setState(() {
          _selectedVehicle = value != null ? _vehicles.firstWhere((vehicle) => vehicle.uid == value) : null;
        });
      },
      items: _vehicles.map<DropdownMenuItem<String>>((Vehicle vehicle) {
        return DropdownMenuItem<String>(
          value: vehicle.uid,
          child: Text('${vehicle.make} ${vehicle.model}'),
        );
      }).toList(),
    );
  }
}



}
