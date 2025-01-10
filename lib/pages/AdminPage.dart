import 'package:flutter/material.dart';
import 'package:mediherb/pages/admin/AddPlant.dart'; // Import the AddPlantPage
import 'package:mediherb/pages/admin/DisplayPlants.dart'; // Import the DisplayPlantPage

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Panel',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Text(
                'Welcome to the Admin Panel',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 40.0),

              // Display Plants Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to DisplayPlantPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DisplayPlantPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.green.shade600,
                  elevation: 5.0,
                  textStyle: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text(
                  'Display Plants',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20.0),

              // Add Plant Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to AddPlantPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddPlantPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.green.shade600,
                  elevation: 5.0,
                  textStyle: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text(
                  'Add Plant',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 30.0),

              // Footer
              const Text(
                'Manage your plants efficiently and seamlessly!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
