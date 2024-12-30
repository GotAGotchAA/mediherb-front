import 'package:flutter/material.dart';
import "pages/login.dart";
import 'pages/home.dart';
import 'pages/register.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomePage(),
      routes: {
        '/home': (context) => HomePage(), // Define your HomePage
      },
    ),
  );
}

