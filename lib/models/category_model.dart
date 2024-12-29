import 'package:flutter/material.dart';


class CategoryModel {
  String name;
  String iconPath;
  Color boxColor;

  CategoryModel({
    required this.name,
    required this.iconPath,
    required this.boxColor,

  });

  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];
    
    categories.add(
      CategoryModel(
        name: 'For sleep',
        iconPath: 'assets/icons/sleep.svg',
        boxColor: Color(0xff92A3FD)
      )
    );

    categories.add(
      CategoryModel(
        name: 'For relaxation',
        iconPath: 'assets/icons/relaxation.svg',
        boxColor: Color(0xff92A3FD)
      )
    );

    categories.add(
      CategoryModel(
        name: 'For concentration',
        iconPath: 'assets/icons/concentration.svg',
        boxColor: Color(0xff92A3FD)
      )
    );

    categories.add(
      CategoryModel(
        name: 'For health',
        iconPath: 'assets/icons/health.svg',
        boxColor: Color(0xff92A3FD)
      )
    );

    return categories;
  }
}