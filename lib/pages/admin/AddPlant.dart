import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({super.key});

  @override
  _AddPlantPageState createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _propertiesController = TextEditingController();
  final TextEditingController _usesController = TextEditingController();
  final TextEditingController _precautionsController = TextEditingController();
  final TextEditingController _interactionsController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  Future<void> addPlant() async {
    final url = Uri.parse('http://localhost:8005/api/plants'); // Replace with your API URL

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'properties': _propertiesController.text,
        'uses': _usesController.text,
        'precautions': _precautionsController.text,
        'interactions': _interactionsController.text,
        'region': _regionController.text,
        'category': _categoryController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plant added successfully!')),
      );
      Navigator.pop(context); // Navigate back after success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add plant. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Plant'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Plant Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter plant name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _propertiesController,
                decoration: const InputDecoration(labelText: 'Properties'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _usesController,
                decoration: const InputDecoration(labelText: 'Uses'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _precautionsController,
                decoration: const InputDecoration(labelText: 'Precautions'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _interactionsController,
                decoration: const InputDecoration(labelText: 'Interactions'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _regionController,
                decoration: const InputDecoration(labelText: 'Region'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addPlant();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'Add Plant',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
