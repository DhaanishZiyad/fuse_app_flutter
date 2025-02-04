import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      "https://fuse-jetstream-production.up.railway.app/api"; // Replace with your actual URL

  static Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];
        int userId = data['user']['id'];

        // Save token locally
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setInt('user_id', userId);

        return token;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  static Future<void> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) return;

      await http.post(
        Uri.parse("$baseUrl/logout"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // Clear token from storage
      await prefs.remove('auth_token');
      await prefs.remove('user_id');
    } catch (e) {
      throw Exception("Logout failed: $e");
    }
  }

  static Future<bool> isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') != null;
  }

  // Fetch all products
  static Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse("$baseUrl/products"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((product) => product as Map<String, dynamic>).toList();
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // Fetch a single product by ID
  static Future<Map<String, dynamic>> fetchProductById(int id) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/products/$id"));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to load product");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // Add a product to cart
  static Future<void> addToCart(
      int productId, String size, int quantity) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      print("Auth Token: $token"); // Debugging line

      if (token == null) {
        throw Exception("User not authenticated");
      }

      final response = await http.post(
        Uri.parse("$baseUrl/cart"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "product_id": productId,
          "size": size,
          "quantity": quantity,
        }),
      );

      print("Response: ${response.body}"); // Debugging line

      if (response.statusCode != 201) {
        throw Exception("Failed to add product to cart");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  static Future<Map<String, dynamic>> fetchCart() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse("$baseUrl/cart"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to fetch cart");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // Remove a single item from the cart
  static Future<void> removeFromCart(int cartItemId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception("User not authenticated");
      }

      final response = await http.delete(
        Uri.parse("$baseUrl/cart/$cartItemId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to remove item from cart");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // Clear entire cart
  static Future<void> clearCart() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception("User not authenticated");
      }

      final response = await http.delete(
        Uri.parse("$baseUrl/cart/clear"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to clear cart");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
