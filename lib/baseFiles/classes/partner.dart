class Partner {
  String name;
  String description;
  String imagePath;
  String url;

  Partner({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.url,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'url': url,
    };
  }

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      name: json['name'],
      description: json['description'],
      imagePath: json['imagePath'],
      url: json['url'],
    );
  }
}
