import 'package:flutter/material.dart';
import 'package:fuse_app/productdetails.dart';
import 'package:fuse_app/services/api_service.dart';
import 'package:fuse_app/productcard.dart';

class Home extends StatefulWidget {
  final Function(Map<String, dynamic>) onProductSelected;

  const Home({super.key, required this.onProductSelected});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      List<Map<String, dynamic>> fetchedProducts = await ApiService.fetchProducts();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching products: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 1100
        ? 6
        : screenWidth > 900
            ? 5
            : screenWidth > 700
                ? 4
                : screenWidth > 530
                    ? 3
                    : 2;

    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Text('Our Products', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2 / 3,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetails(productId: product['id']),
                              ),
                            );
                          },
                          child: ProductCard(
                            name: product['name'] ?? 'Unknown Product',
                            imagePath: "https://fuse-jetstream-production.up.railway.app/storage/${product['image_path']}",
                            oldPrice: double.tryParse(product['old_price'].toString()) ?? 0.0,
                            currentPrice: double.tryParse(product['current_price'].toString()) ?? 0.0,
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
