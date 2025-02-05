import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Import your API service

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<dynamic> cartItems = [];
  double subtotal = 0.0;
  double shipping = 0.0;
  double total = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      final cartData = await ApiService.fetchCart();

      print("Cart Data from API: $cartData"); // Debugging

      setState(() {
        cartItems = cartData['cart_items'] ?? [];

        // Ensure numeric values are properly converted to double
        subtotal = (cartData['subtotal'] is int)
            ? (cartData['subtotal'] as int).toDouble()
            : double.tryParse(cartData['subtotal'].toString()) ?? 0.0;

        shipping = (cartData['shipping'] is int)
            ? (cartData['shipping'] as int).toDouble()
            : double.tryParse(cartData['shipping'].toString()) ?? 0.0;

        total = (cartData['total'] is int)
            ? (cartData['total'] as int).toDouble()
            : double.tryParse(cartData['total'].toString()) ?? 0.0;

        isLoading = false;
      });

      print(
          "Subtotal: $subtotal, Shipping: $shipping, Total: $total"); // Debugging
    } catch (e) {
      print("Error fetching cart: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Remove a single item from the cart
  Future<void> removeCartItem(int cartItemId) async {
    try {
      await ApiService.removeFromCart(cartItemId);
      fetchCartItems(); // Refresh cart after removal
    } catch (e) {
      print("Error removing item: $e");
    }
  }

  // Clear entire cart
  Future<void> clearCart() async {
    try {
      await ApiService.clearCart();
      fetchCartItems(); // Refresh cart after clearing
    } catch (e) {
      print("Error clearing cart: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Text(
                      'Cart',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Display cart items
                  ...cartItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8.0),
                      child: Card(
                        child: ListTile(
                          leading: Image.network(
                            item[
                                'product_image'], // Now it should return a full URL
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item['product_name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('LKR. ${item['current_price']}'),
                              Text('Size: ${item['size']}'), // Show item size
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'QTY: ${item['quantity']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    removeCartItem(item['id']), // Remove item
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  // Cart calculations
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Align(
                      alignment:
                          Alignment.centerRight, // Align content to the right
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.end, // Align text to the right
                        children: [
                          Text('Subtotal: LKR. ${subtotal.toStringAsFixed(2)}'),
                          Text('Shipping: LKR. ${shipping.toStringAsFixed(2)}'),
                          Text(
                            'Total: LKR. ${total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Checkout button (aligned to the right)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: const Text(
                              'Check Out',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              // Navigate to checkout page
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
