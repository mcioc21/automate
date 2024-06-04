import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  String uid;
  DateTime dateTime;
  String description;
  String userId;
  String workshopId;
  String? vehicleId;

  Appointment({
    required this.uid,
    required this.dateTime,
    required this.description,
    required this.userId,
    required this.workshopId,
    this.vehicleId,
  });

  factory Appointment.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Appointment(
      uid: snapshot.id,
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      description: data['description'],
      userId: data['userId'],
      workshopId: data['workshopId'],
      vehicleId: data['vehicleId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dateTime': Timestamp.fromDate(dateTime),
      'description': description,
      'userId': userId,
      'workshopId': workshopId,
      'vehicleId': vehicleId,
    };
  }
}

Future<List<DateTime>> getAvailableTimeSlots(int workshopId, DateTime date) async {
  var startOfDay = DateTime(date.year, date.month, date.day, 9);
  var endOfDay = DateTime(date.year, date.month, date.day, 17);

  // Query Firestore for appointments within the specified date range
  var querySnapshot = await FirebaseFirestore.instance
    .collection('appointments')
    .where('workshopId', isEqualTo: workshopId.toString()) // Convert workshopId to String for comparison
    .where('dateTime', isGreaterThanOrEqualTo: startOfDay)
    .where('dateTime', isLessThanOrEqualTo: endOfDay)
    .get();

  // Extract the DateTime objects from the query results
  List<DateTime> takenSlots = querySnapshot.docs.map((doc) => (doc['dateTime'] as Timestamp).toDate()).toList();

  // Generate all possible slots within the specified time range
  List<DateTime> allPossibleSlots = List.generate(8, (index) => DateTime(date.year, date.month, date.day, 9 + index));

  // Convert takenSlots to String for comparison
  List<String> takenSlotsFormatted = takenSlots.map((slot) => slot.toString()).toList();

  // Filter out taken slots
  return allPossibleSlots.where((slot) => !takenSlotsFormatted.contains(slot.toString())).toList();
}



