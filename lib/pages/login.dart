import 'package:flutter/material.dart';
import 'register.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';  // Import for JSON decoding
import 'package:http/http.dart' as http;  // Import the http package
import 'home_page.dart';  // Import the HomePage
import 'package:shared_preferences/shared_preferences.dart';  // For storing the token

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to perform the API login request
  Future<bool> loginApi(String email, String password) async {
    final url = Uri.parse('http://localhost:8005/auth/login');  // Replace with your API URL

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Parse the response body and extract the token
      var data = json.decode(response.body);
      String token = data['token'];  // Assuming the token is inside the 'token' field

      // Save the token in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('auth_token', token);

      print('Login successful: ${data}');
      return true;  // Returning true for successful login
    } else {
      print('Login failed: ${response.body}');
      return false;  // Returning false for failed login
    }
  }

  // Handle login when form is validated
  void _login() async {
    if (_formKey.currentState!.validate()) {
      bool success = await loginApi(_emailController.text, _passwordController.text);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logged in successfully with: ${_emailController.text}')),
        );
        // Navigate to the HomePage after a successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed! Please check your credentials')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 246, 229, 1),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Mediherb',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 25, 61, 14),
                        fontFamily: 'CustomFont',
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    SvgPicture.asset(
                      'assets/icons/plant.svg',
                      height: 28.0,
                      width: 28.0,
                      color: Color.fromARGB(255, 25, 61, 14),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Color.fromARGB(255, 25, 61, 14)),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Color.fromARGB(255, 25, 61, 14)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.green, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.black54, width: 1.5),
                    ),
                    prefixIcon: const Icon(Icons.email, color: Colors.black54),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Color.fromARGB(255, 25, 61, 14)),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Color.fromARGB(255, 25, 61, 14)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.green, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.black54, width: 1.5),
                    ),
                    prefixIcon: const Icon(Icons.lock, color: Colors.black54),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    // Handle forgotten password logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Forgot Password tapped!')),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    "Don't Have An Account? Register",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
