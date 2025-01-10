// lib/pages/admin/DisplayPlantPage.dart

import 'package:flutter/material.dart';
import 'package:mediherb/model/plant_model.dart';
import 'package:mediherb/services/api_service.dart';
import 'package:mediherb/pages/admin/EditPlant.dart'; // Import the EditPlantPage

class DisplayPlantPage extends StatefulWidget {
  const DisplayPlantPage({super.key});

  @override
  _DisplayPlantPageState createState() => _DisplayPlantPageState();
}

class _DisplayPlantPageState extends State<DisplayPlantPage> {
  List<PlantModel> plants = [];
  List<PlantModel> filteredPlants = [];
  bool isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getPlants();
    _searchController.addListener(_filterPlants);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterPlants);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getPlants() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<PlantModel> fetchedPlants = await ApiService.getAllPlants();
      setState(() {
        plants = fetchedPlants;
        filteredPlants = plants; // Initially, all plants are visible
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterPlants() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredPlants = plants.where((plant) {
        return plant.name.toLowerCase().contains(query) ||
            plant.category.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display Plants', style: TextStyle(color: Colors.green)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  SizedBox(height: 20),
                  _buildPlantList(),
                ],
              ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search for plants",
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.green,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(12),
        ),
      ),
    );
  }

  Widget _buildPlantList() {
    return Expanded(
      child: GridView.builder(
        itemCount: filteredPlants.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          final plant = filteredPlants[index];
          return GestureDetector(
            onTap: () {
              // Navigate to EditPlantPage and pass the selected plant
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPlantPage(plant: plant),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              shadowColor: Colors.grey.withOpacity(0.2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Placeholder image handling
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      image: DecorationImage(
                        image: AssetImage('assets/images/plant_placeholder.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      plant.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      plant.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${plant.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Icon(
                          Icons.favorite_border,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
