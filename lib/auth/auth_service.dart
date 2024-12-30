import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // For storing token securely

class AuthService {
  final String baseUrl = 'http://your-api-url/auth'; // Replace with your backend URL
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Login API call
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Parse the JWT token from the response
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String token = responseData['token'];
        final int expiresIn = responseData['expiresIn'];

        // Store the token securely
        await _storage.write(key: 'jwtToken', value: token);

        return {
          'success': true,
          'message': 'Login successful',
          'token': token,
          'expiresIn': expiresIn,
        };
      } else {
        return {
          'success': false,
          'message': 'Login failed: ${response.body}',
        };
      }
    } catch (error) {
      return {
        'success': false,
        'message': 'An error occurred: $error',
      };
    }
  }

  // Sign Up API call
  Future<Map<String, dynamic>> signUp(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Registration successful',
        };
      } else {
        return {
          'success': false,
          'message': 'Registration failed: ${response.body}',
        };
      }
    } catch (error) {
      return {
        'success': false,
        'message': 'An error occurred: $error',
      };
    }
  }

  // Get the stored JWT token
  Future<String?> getToken() async {
    return await _storage.read(key: 'jwtToken');
  }
}
