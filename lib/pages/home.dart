import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediherb/model/plant_model.dart'; // Import the Plant model
import 'package:mediherb/api/api_service.dart'; // Import the API service

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PlantModel> plants = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getPlants();
  }

  // Fetch plants from the backend
  Future<void> _getPlants() async {
    setState(() {
      isLoading = true;
    });

    List<PlantModel> fetchedPlants = await ApiService.getAllPlants();

    setState(() {
      plants = fetchedPlants;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      backgroundColor: const Color.fromRGBO(240, 246, 229, 1),
      drawer: _buildDrawer(), // Add Drawer
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchBar(),
          SizedBox(height: 40),
          _plantSection(),
          Spacer(),
          _createPlantButton(),
        ],
      ),
    );
  }

  // Section to display all plants
  Column _plantSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'Plants',
            style: TextStyle(
              color: Color.fromARGB(255, 25, 61, 14),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 15),
        isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                height: 200,
                child: ListView.builder(
                  itemCount: plants.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  itemBuilder: (context, index) {
                    return Container(
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Placeholder for plant image (replace with actual image)
                          Container(
                            width: 50,
                            height: 50,
                            color: Colors.green,
                          ),
                          Text(
                            plants[index].name,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }

  // Search bar widget
  Container _searchBar() {
    return Container(
      margin: EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0,
          )
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(15),
          hintText: "Search for a herb",
          hintStyle: TextStyle(
            color: Color(0xffDDDADA),
            fontSize: 14,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              color: Color.fromARGB(255, 25, 61, 14),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // Create Plant Button
  Padding _createPlantButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: () {
          // Navigate to the plant creation page (to be implemented)
        },
        child: Text('Create Plant'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        ),
      ),
    );
  }

  // AppBar
  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'MediHerb',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 25, 61, 14),
              fontFamily: 'CustomFont',
            ),
          ),
          SizedBox(width: 8.0),
          SvgPicture.asset(
            'assets/icons/your_image.svg',
            height: 24.0,
            width: 24.0,
            color: Color.fromARGB(255, 25, 61, 14),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(10),
              child: SvgPicture.asset(
                'assets/icons/menu.svg',
                height: 20,
                width: 20,
                color: Color.fromARGB(255, 25, 61, 14),
              ),
              decoration: BoxDecoration(
                color: Color(0xfff7f8f8),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      ),
      actions: [
        GestureDetector(
          onTap: () {
            // Action when the action icon is tapped
          },
          child: Container(
            alignment: Alignment.center,
            width: 37,
            margin: EdgeInsets.all(10),
            child: SvgPicture.asset(
              'assets/icons/user.svg',
              height: 20,
              width: 20,
              color: Color.fromARGB(255, 25, 61, 14),
            ),
            decoration: BoxDecoration(
              color: Color(0xfff7f8f8),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  // Drawer
  Drawer _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 38.0),
              children: [
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('About'),
                  onTap: () {
                    // Navigate to About
                  },
                ),
                ListTile(
                  leading: Icon(Icons.contact_page),
                  title: Text('Contact'),
                  onTap: () {
                    // Navigate to Contact
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
