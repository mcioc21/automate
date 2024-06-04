import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  String uid;
  DateTime dateTime;
  String description;
  String userId;
  String workshopId;

  Appointment({
    required this.uid,
    required this.dateTime,
    required this.description,
    required this.userId,
    required this.workshopId,
  });

  factory Appointment.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Appointment(
      uid: snapshot.id,
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      description: data['description'],
      userId: data['userId'],
      workshopId: data['workshopId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dateTime': Timestamp.fromDate(dateTime),
      'description': description,
      'userId': userId,
      'workshopId': workshopId,
    };
  }
}

Future<List<DateTime>> getAvailableTimeSlots(int workshopId, DateTime date) async {
  var startOfDay = DateTime(date.year, date.month, date.day);
  var endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
  var appointments = await FirebaseFirestore.instance
    .collection('appointments')
    .where('workshopId', isEqualTo: workshopId)
    .where('dateTime', isGreaterThanOrEqualTo: startOfDay)
    .where('dateTime', isLessThanOrEqualTo: endOfDay)
    .get();

  // Assuming appointments are on hourly slots for simplicity
  List<DateTime> allPossibleSlots = List.generate(24, (index) => DateTime(date.year, date.month, date.day, index));
  List<DateTime> takenSlots = appointments.docs
    .map((doc) => (doc.data()['dateTime'] as Timestamp).toDate())
    .cast<DateTime>()
    .toList();
  
  return allPossibleSlots.where((slot) => !takenSlots.contains(slot)).toList();
}


