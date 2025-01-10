class PlantModel {
  int id;
  String name;
  String description;
  String properties;
  String uses;
  String precautions;
  String interactions;
  String region;
  String category;
  double price;

  PlantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.properties,
    required this.uses,
    required this.precautions,
    required this.interactions,
    required this.region,
    required this.category,
    required this.price,
  });

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      properties: json['properties'] ?? '',
      uses: json['uses'] ?? '',
      precautions: json['precautions'] ?? '',
      interactions: json['interactions'] ?? '',
      region: json['region'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] as num).toDouble(),
    );
  }
}
