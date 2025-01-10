import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'EditUserPage.dart'; // Import the EditUserPage

class UserDetailPage extends StatefulWidget {
  final String email;

  UserDetailPage({required this.email});

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  bool isLoading = true;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final email = widget.email;

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8005/users/email/$email'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          userData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        // Handle error here if the response is not OK
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle exception (e.g., network issues)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        backgroundColor: Colors.green,
        elevation: 4,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userData == null
              ? Center(child: Text("User not found", style: TextStyle(fontSize: 18, color: Colors.grey)))
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Full Name:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      SizedBox(height: 5),
                      Text(
                        userData!['fullName'] ?? 'N/A',
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Email:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      SizedBox(height: 5),
                      Text(
                        userData!['email'] ?? 'N/A',
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Created At:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      SizedBox(height: 5),
                      Text(
                        userData!['createdAt'] ?? 'N/A',
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to EditUserPage with userId
                          String userId = userData!['id'].toString();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditUserPage(userId: userId),
                            ),
                          );
                        },
                        child: Text('Edit User'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      ),
                    ],
                  ),
                ),
    );
  }
}
