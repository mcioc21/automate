import 'dart:convert';

class Discount {
  int id;
  String shortDescription;
  String longDescription;
  String imagePath;

  Discount({
    required this.id,
    required this.shortDescription,
    required this.longDescription,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shortDescription': shortDescription,
      'longDescription': longDescription,
      'imagePath': imagePath,
    };
  }

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      id: json['id'],
      shortDescription: json['shortDescription'],
      longDescription: json['longDescription'],
      imagePath: json['imagePath'],
    );
  }

  static String encode(List<Discount> discounts) {
    return json.encode(
      discounts.map<Map<String, dynamic>>((discount) => discount.toJson()).toList(),
    );
  }

  static List<Discount> decode(String discountsStr) {
    return (json.decode(discountsStr) as List<dynamic>)
        .map<Discount>((item) => Discount.fromJson(item))
        .toList();
  }
}
