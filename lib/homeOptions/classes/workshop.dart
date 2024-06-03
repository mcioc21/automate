import 'dart:convert';

import 'package:flutter/services.dart';

class Workshop {
  final int id;
  final double latitude;
  final double longitude;
  final String name;
  final String description;
  final String photo;
  final String category;
  final String address;

  Workshop({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.description,
    required this.photo,
    required this.category,
    required this.address,
  });

  factory Workshop.fromJson(Map<String, dynamic> json) {
    return Workshop(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      name: json['name'],
      description: json['description'],
      photo: json['photo'],
      category: json['category'],
      address: json['address'],
    );
  }

  // Convert a map to a Workshop object
  factory Workshop.fromMap(Map<String, dynamic> map) {
    return Workshop(
      id: map['id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      name: map['name'],
      description: map['description'],
      photo: map['photo'],
      category: map['category'],
      address: map['address'],
    );
  }

  // Convert a Workshop object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'description': description,
      'photo': photo,
      'category': category,
      'address': address,
    };
  }
}

Future<List<Workshop>> loadWorkshops(String category) async {
  final String response = await rootBundle.loadString('assets/workshops.json');
  final data = await json.decode(response) as List;
  return data.map((json) => Workshop.fromJson(json))
             .where((workshop) => workshop.category == category)
             .toList();
}