class PlantModel {
  final int id;
  final String name;
  final String category;
  final String region;

  PlantModel({required this.id, required this.name, required this.category, required this.region});

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      region: json['region'],
    );
  }
}
