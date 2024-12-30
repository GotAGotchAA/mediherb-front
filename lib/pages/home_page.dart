import 'package:flutter/material.dart';
import 'package:mediherb/model/plant_model.dart';
import 'package:mediherb/services/api_service.dart'; // Import ApiService
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediherb/detail/ProductDetailPage.dart'; // Import the ProductDetailPage

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PlantModel> plants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getPlants();
  }

  Future<void> _getPlants() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<PlantModel> fetchedPlants = await ApiService.getAllPlants();
      setState(() {
        plants = fetchedPlants;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error (e.g., show a snack bar or error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Medicinal Plants',
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.green),
          onPressed: () {
            Scaffold.of(context).openDrawer();
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
              // Handle search action
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context), // Add the drawer
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

  // Build the drawer
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
          ListTile(
            leading: Icon(Icons.category, color: Colors.green),
            title: Text('Categories'),
            onTap: () {
              Navigator.pushNamed(context, '/categories');
            },
          ),
          ListTile(
            leading: Icon(Icons.search, color: Colors.green),
            title: Text('Search'),
            onTap: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          Spacer(), // Pushes the Logout button to the bottom
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }

  // Search Bar Widget
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
        decoration: InputDecoration(
          hintText: "Search for plants",
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              color: Colors.green,
              height: 20,
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(12),
        ),
      ),
    );
  }

  // Plant List Section
  Widget _buildPlantList() {
    return Expanded(
      child: GridView.builder(
        itemCount: plants.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          final plant = plants[index];
          return GestureDetector(
            onTap: () {
              // Navigate to the ProductDetailPage and pass the selected plant
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
                  // Placeholder for plant image
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
                          '\$${Text("price")}',
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
