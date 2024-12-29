import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediherb/models/category_model.dart';
import 'package:mediherb/pages/login.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories = [];

  void _getCategories() {
    categories = CategoryModel.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    _getCategories();
    return Scaffold(
      appBar: appBar(context),
      backgroundColor: const Color.fromRGBO(240, 246, 229, 1),
      drawer: _buildDrawer(), // Add Drawer
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchBar(),
          SizedBox(height: 40),
          _categorieSection(),
        ],
      ),
    );
  }

  Column _categorieSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'Category',
            style: TextStyle(
              color: Color.fromARGB(255, 25, 61, 14),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 15),
        Container(
          height: 120,
          color: const Color.fromRGBO(240, 246, 229, 1),
          child: ListView.separated(
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 20, right: 20),
            separatorBuilder: (context, index) => SizedBox(width: 25),
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                decoration: BoxDecoration(
                  color: categories[index].boxColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(240, 246, 229, 1),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(categories[index].iconPath),
                      ),
                    ),
                    Text(
                      categories[index].name,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 10,
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

  Drawer _buildDrawer() {
  return Drawer(
    child: Column(
      children: [
        // This will contain all the other ListTiles at the top
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
        // This is your ListTile at the bottom
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
      ],
    ),
  );
  }
}
