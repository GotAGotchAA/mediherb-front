import 'package:flutter/material.dart';
import 'package:mediherb/model/plant_model.dart';

class ProductDetailPage extends StatelessWidget {
  final PlantModel plant;

  // Constructor to accept plant details from the HomePage
  const ProductDetailPage({Key? key, required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.name),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder for plant image
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.green.withOpacity(0.3),
              ),
              child: Center(
                child: Icon(
                  Icons.image,
                  color: Colors.white,
                  size: 100,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              plant.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Category: ${plant.category}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              'Description: ${plant.description}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '\$${Text("price")}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Add to cart or any other action here
              },
              child: Text('Add to Cart'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
