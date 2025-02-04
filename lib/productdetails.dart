import 'package:flutter/material.dart';
import 'package:fuse_app/services/api_service.dart';

class ProductDetails extends StatefulWidget {
  final int productId;

  const ProductDetails({super.key, required this.productId});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isLoading = true;
  Map<String, dynamic>? productDetails;
  String selectedSize = 'S'; // Default size selection
  int quantity = 1; // Default quantity

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  void fetchProductDetails() async {
    try {
      Map<String, dynamic> product =
          await ApiService.fetchProductById(widget.productId);
      setState(() {
        productDetails = product;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching product details: $e");
    }
  }

  void addToCart() async {
    try {
      await ApiService.addToCart(widget.productId, selectedSize, quantity);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to cart successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to cart: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (productDetails == null) {
      return const Center(child: Text("Product not found"));
    }

    String name = productDetails?['name'] ?? 'Unknown Product';
    String imagePath =
        "https://fuse-jetstream-production.up.railway.app/storage/${productDetails?['image_path'] ?? 'default_image.jpg'}";
    double oldPrice =
        double.tryParse(productDetails!['old_price'].toString()) ?? 0.0;
    double currentPrice =
        double.tryParse(productDetails!['current_price'].toString()) ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset('images/logo_black.png', height: 32),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(imagePath, fit: BoxFit.contain),
            const SizedBox(height: 20),
            Text(name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              'LKR. ${oldPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                  decoration: TextDecoration.lineThrough, color: Colors.grey),
            ),
            const SizedBox(height: 5),
            Text(
              'LKR. ${currentPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                  color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Size Selection Dropdown
            const Text("Select Size:"),
            DropdownButton<String>(
              value: selectedSize.isNotEmpty
                  ? selectedSize
                  : 'S', // Ensure it never assigns null
              items: ['S', 'M', 'L', 'XL', '2XL']
                  .map((size) =>
                      DropdownMenuItem(value: size, child: Text(size)))
                  .toList(),
              onChanged: (newSize) {
                setState(() {
                  selectedSize = newSize!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Quantity Selector
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() => quantity--);
                    }
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text(quantity.toString(), style: const TextStyle(fontSize: 18)),
                IconButton(
                  onPressed: () {
                    setState(() => quantity++);
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Add to Cart Button
            ElevatedButton(
              onPressed: addToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Add to Cart',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
