class PlantModel {
  final int id;
  final String name;
  final String description;
  final String properties;
  final String uses;
  final String precautions;
  final String interactions;
  final String region;
  final String category;
  final double price; // Add the price field

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
    required this.price, // Include it in the constructor
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
      price: (json['price'] as num).toDouble(), // Safely cast to double
    );
  }
}
