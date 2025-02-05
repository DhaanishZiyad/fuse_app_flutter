import 'package:flutter/material.dart';
import 'package:fuse_app/productcard.dart';
import 'package:fuse_app/services/api_service.dart';
import 'package:fuse_app/productdetails.dart';

class Wishlist extends StatefulWidget {
  final Function(Map<String, dynamic>) onProductSelected;

  const Wishlist({super.key, required this.onProductSelected});

  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  List<Map<String, dynamic>> wishlistItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    try {
      final items = await ApiService.fetchWishlist();
      setState(() {
        wishlistItems = items;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching wishlist: $e");
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = (screenWidth > 1100)
        ? 6
        : (screenWidth > 900)
            ? 5
            : (screenWidth > 700)
                ? 4
                : (screenWidth > 530)
                    ? 3
                    : 2;

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : wishlistItems.isEmpty
              ? const Center(child: Text("Your wishlist is empty"))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Row(
                          children: [
                            Text(
                              'Wishlist',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 2 / 3,
                          ),
                          itemCount: wishlistItems.length,
                          itemBuilder: (context, index) {
                            final product = wishlistItems[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetails(
                                        productId: product['product_id']),
                                  ),
                                );
                              },
                              child: ProductCard(
                                productId: product['product_id'],
                                name: product['product_name'] ??
                                    'Unknown Product',
                                imagePath: product['product_image'] ?? '',
                                oldPrice: double.tryParse(
                                        product['old_price'].toString()) ??
                                    0.0,
                                currentPrice: double.tryParse(
                                        product['current_price'].toString()) ??
                                    0.0,
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
