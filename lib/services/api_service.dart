// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mediherb/model/plant_model.dart';  // Import the PlantModel

class ApiService {
  static const String baseUrl = 'http://localhost:8005/api/plants'; // Replace with your backend URL

  // Fetch all plants from the backend
  static Future<List<PlantModel>> getAllPlants() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => PlantModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load plants');
    }
  }

  // Additional methods for filtering, searching, and pagination can be added here if needed
}
