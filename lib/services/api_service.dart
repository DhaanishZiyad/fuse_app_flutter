import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://fuse-jetstream-production.up.railway.app/api"; // Replace with your actual URL

  static Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/products"));

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

  // New method to fetch a single product by ID
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
}
