import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediherb/model/plant_model.dart';
import 'package:mediherb/services/api_service.dart';
import 'package:mediherb/detail/ProductDetailPage.dart';
import 'package:mediherb/pages/UserDetailPage.dart'; // Import UserDetailPage

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  Future<String?> _getEmailFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');  // Retrieve email from SharedPreferences
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'MediHerb',
        style: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 25, 61, 14),
          fontFamily: 'CustomFont',
        ),
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
              'assets/icons/user.svg',
              color: Colors.green,
              height: 20,
            ),
            onPressed: () async {
              String? email = await _getEmailFromPrefs();
              if (email != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetailPage(email: email),
                  ),
                );
              }
            },
          )
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
                  _buildSearchBar(),
                  SizedBox(height: 20),
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
            decoration: BoxDecoration(color: Colors.green),
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
            routeName: '/',
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
            text: 'Region',
            routeName: '/regions',
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

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required String routeName,
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : Colors.green,
      ),
      title: Text(
        text,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.black,
        ),
      ),
      onTap: () {
        if (isLogout) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            routeName,
            (route) => false,
          );
        } else {
          Navigator.pushNamed(context, routeName);
        }
      },
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
                  // Placeholder image handling
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.asset(
                        'assets/images/plant_placeholder.png',
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
