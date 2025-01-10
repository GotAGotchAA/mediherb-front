import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert'; // Import dart:convert for JSON decoding

class EditUserPage extends StatefulWidget {
  final String userId;

  EditUserPage({required this.userId});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  // Initialize controllers for the fields you want to edit
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8005/users/${widget.userId}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> userData = json.decode(response.body);
        setState(() {
          _nameController.text = userData['fullName'];
          _emailController.text = userData['email'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateUser() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        errorMessage = 'Passwords do not match';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final userUpdateData = {
        'fullName': _nameController.text,
        'email': _emailController.text,
        'password': _newPasswordController.text.isNotEmpty
            ? _newPasswordController.text
            : _currentPasswordController.text, // Update password if provided
        'role': "USER",
      };

      final response = await http.put(
        Uri.parse('http://localhost:8005/users/${widget.userId}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userUpdateData),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context); // Go back to the previous page on success
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to update user';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error updating user';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  Text('Full Name:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: 'Enter full name'),
                  ),
                  SizedBox(height: 15),
                  Text('Email:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: 'Enter email'),
                  ),
                  SizedBox(height: 15),
                  Text('Current Password:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _currentPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Enter current password'),
                  ),
                  SizedBox(height: 15),
                  Text('New Password:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Enter new password'),
                  ),
                  SizedBox(height: 15),
                  Text('Confirm New Password:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Confirm new password'),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _updateUser,
                    child: Text('Save Changes'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ],
              ),
            ),
    );
  }
}
