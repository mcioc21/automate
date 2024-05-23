class Appointment {
  String uid;
  DateTime dateTime;
  String description;
  String location;

  Appointment({
    required this.uid,
    required this.dateTime,
    required this.description,
    required this.location,
  });

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      uid: map['uid'],
      dateTime: DateTime.parse(map['dateTime']),
      description: map['description'],
      location: map['location'],
    );
  }

  // Method to convert an appointment instance to a map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'dateTime': dateTime.toIso8601String(),
      'description': description,
      'location': location,
    };
  }
}