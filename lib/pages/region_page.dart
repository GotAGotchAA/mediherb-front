import 'package:flutter/material.dart';
import 'package:mediherb/model/plant_model.dart';
import 'package:mediherb/services/api_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediherb/detail/ProductDetailPage.dart';
import 'dart:convert'; // For json decoding
import 'package:http/http.dart' as http; // For HTTP requests
import 'home_page.dart'; // Import the HomePage

class RegionPage extends StatefulWidget {
  @override
  _RegionPageState createState() => _RegionPageState();
}

class _RegionPageState extends State<RegionPage> {
  List<PlantModel> plants = [];
  List<PlantModel> filteredPlants = [];
  bool isLoading = true;
  String? selectedRegion; // For storing selected region
  List<String> regions = []; // Will be populated dynamically from the API

  @override
  void initState() {
    super.initState();
    _getPlants();
    _getRegions();
  }

  // Fetching the list of plants
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
      // Handle error (e.g., show a snack bar or error message)
    }
  }

  // Fetch regions from the API
  Future<void> _getRegions() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8005/api/plants/metadata'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          regions = List<String>.from(data['regions'] ?? []); // Assuming response contains a 'regions' field
        });
      } else {
        // Handle error response
        print('Failed to load regions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching regions: $e');
    }
  }

  // Filter plants based on the selected region
  void _filterPlantsByRegion(String? region) {
    setState(() {
      selectedRegion = region;
      if (region != null) {
        filteredPlants = plants.where((plant) => plant.region == region).toList();
      } else {
        filteredPlants = plants;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Regions',
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.green),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              color: Colors.green,
              height: 20,
            ),
            onPressed: () {
              // Handle search action if needed
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown for selecting region
                  _buildRegionDropdown(),
                  SizedBox(height: 16),
                  _buildPlantList(),
                ],
              ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Center(
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.home,
            text: 'Home',
            routeName: '/home', // Navigate to HomePage
          ),
          _buildDrawerItem(
            context,
            icon: Icons.category,
            text: 'Categories',
            routeName: '/categories',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.location_on,
            text: 'Regions',
            routeName: '/regions',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.search,
            text: 'Search',
            routeName: '/search',
          ),
          Spacer(),
          Divider(),
          _buildDrawerItem(
            context,
            icon: Icons.logout,
            text: 'Logout',
            routeName: '/login',
            isLogout: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon,
      required String text,
      required String routeName,
      bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.green),
      title: Text(
        text,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.black,
        ),
      ),
      onTap: () {
        if (isLogout) {
          Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
        } else {
          Navigator.pushNamed(context, routeName);
        }
      },
    );
  }

  // Dropdown widget for selecting a region
  Widget _buildRegionDropdown() {
    return DropdownButton<String>(
      value: selectedRegion,
      hint: Text('Select Region'),
      items: regions.map((String region) {
        return DropdownMenuItem<String>(
          value: region,
          child: Text(region),
        );
      }).toList(),
      onChanged: (String? newRegion) {
        _filterPlantsByRegion(newRegion);
      },
      isExpanded: true,
    );
  }

  // Displays the list of plants based on the selected region
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(plant: plant),
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
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      color: Colors.green.withOpacity(0.3),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 40,
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
                      plant.region, // Display the region of the plant
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
                        IconButton(
                          icon: Icon(
                            Icons.favorite_border,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            // Handle favorite button action
                          },
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
