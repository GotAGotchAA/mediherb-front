import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mediherb/model/plant_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8005/api/plants';

  static Future<List<PlantModel>> getAllPlants() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PlantModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load plants');
      }
    } catch (e) {
      throw Exception('Error fetching plants: $e');
    }
  }
}
