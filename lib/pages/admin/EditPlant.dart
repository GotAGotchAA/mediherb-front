import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mediherb/model/plant_model.dart';

class EditPlantPage extends StatefulWidget {
  final PlantModel plant;

  const EditPlantPage({super.key, required this.plant});

  @override
  _EditPlantPageState createState() => _EditPlantPageState();
}

class _EditPlantPageState extends State<EditPlantPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plant.name);
    _descriptionController = TextEditingController(text: widget.plant.description);
    _categoryController = TextEditingController(text: widget.plant.category);
    _priceController = TextEditingController(text: widget.plant.price.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _updatePlant() async {
    final url = 'http://localhost:8005/api/plants/${widget.plant.id}';  // Replace with actual API URL
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'category': _categoryController.text,
        'price': double.tryParse(_priceController.text),
      }),
    );

    if (response.statusCode == 200) {
      // Successfully updated the plant
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plant updated successfully!')),
      );
      Navigator.pop(context);
    } else {
      // Error updating the plant
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update plant')),
      );
    }
  }

  Future<void> _deletePlant() async {
    final url = 'http://localhost:8005/api/plants/${widget.plant.id}';  // Replace with actual API URL
    final response = await http.delete(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      // Successfully deleted the plant
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plant deleted successfully!')),
      );
      Navigator.pop(context); // Go back to the previous screen after deletion
    } else {
      // Error deleting the plant
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete plant')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Plant'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Plant Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updatePlant,
              child: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _deletePlant,
              child: const Text('Delete Plant'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
