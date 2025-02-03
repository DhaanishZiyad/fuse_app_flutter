import 'package:flutter/material.dart';
import 'package:fuse_app/productcard.dart';

class Wishlist extends StatelessWidget {
  final Function(Map<String, dynamic>) onProductSelected;

  const Wishlist({super.key, required this.onProductSelected});

  @override
  Widget build(BuildContext context) {
    // Get screen width using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;

    // Set the number of items per row based on screen width
    int crossAxisCount;
    if (screenWidth > 1100) {
      crossAxisCount = 6; // 5 items for large screens
    } else if (screenWidth > 900) {
      crossAxisCount = 5; // 3 items for medium screens
    } else if (screenWidth > 700) {
      crossAxisCount = 4; // 3 items for medium screens
    } else if (screenWidth > 530){
      crossAxisCount = 3; // 2 items for small screens
    } else  {
      crossAxisCount = 2; // 3 items for medium screens
    }

    // List of product details
    final products = [
      {
        'name': 'FUSE X CSK',
        'imagePath': 'images/test_post.png',
        'oldPrice': 3500.00,
        'currentPrice': 2950.00,
      },
      {
        'name': 'FUSE X BMS',
        'imagePath': 'images/test_post2.png',
        'oldPrice': 3500.00,
        'currentPrice': 2950.00,
      },
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Text(
                    'Wishlist',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(), // Disable scrolling for GridView inside ScrollView
                shrinkWrap: true, // Wrap GridView height to content
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount, // Number of items per row
                  crossAxisSpacing: 10, // Horizontal spacing
                  mainAxisSpacing: 10, // Vertical spacing
                  childAspectRatio: 2 / 3, // Aspect ratio of items
                ),
                itemCount: products.length, // Set to the actual number of products
                itemBuilder: (context, index) {
                  final product = products[index];

                  return GestureDetector(
                    onTap: () {
                      // Call the callback with selected product details
                      onProductSelected(product);
                    },
                    child: ProductCard(
                      name: product['name'] as String,
                      imagePath: product['imagePath'] as String,
                      oldPrice: product['oldPrice'] as double,
                      currentPrice: product['currentPrice'] as double,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
