import 'package:flutter/material.dart';
import 'package:mediherb/model/plant_model.dart';
import 'package:mediherb/services/api_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediherb/detail/ProductDetailPage.dart';
import 'package:mediherb/pages/region_page.dart'; // Import the RegionPage
import 'package:mediherb/pages/home_page.dart'; // Import the HomePage

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<PlantModel> plants = [];
  List<PlantModel> filteredPlants = [];
  bool isLoading = true;
  String? selectedCategory;

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

  void _filterPlantsByCategory(String? category) {
    setState(() {
      selectedCategory = category;
      if (category == null || category.isEmpty) {
        filteredPlants = plants; // Show all plants if no category is selected
      } else {
        filteredPlants = plants
            .where((plant) => plant.category == category)
            .toList(); // Filter plants by selected category
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get unique categories from plants for the dropdown
    List<String> categories = plants
        .map((plant) => plant.category)
        .toSet()
        .toList(); // Get distinct categories

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
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
                  // Dropdown to select category
                  DropdownButton<String>(
                    value: selectedCategory,
                    hint: Text('Select Category'),
                    onChanged: _filterPlantsByCategory,
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text('All Categories'),
                      ),
                      ...categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildCategoryList(),
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
            text: 'Home', // Home button
            routeName: '/home', // Route to your home page
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
            text: 'Regions', // New "Region" button
            routeName: '/regions', // Route to RegionPage
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

  Widget _buildCategoryList() {
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
