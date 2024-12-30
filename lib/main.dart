import 'package:flutter/material.dart';
import 'pages/home_page.dart'; // Ensure this import path is correct
import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/categories_page.dart';
import 'pages/search_page.dart';
import 'pages/user_profile_page.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Medicinal Herbs',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(), // Default page when the app starts
      routes: {
        '/home': (context) => HomePage(), // Properly defined route
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/categories': (context) => CategoriesPage(),
        '/search': (context) => SearchPage(),
        '/profile': (context) => UserProfilePage(),
      },
    ),
  );
}
