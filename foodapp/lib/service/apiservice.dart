import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/product.dart';

class ApiService {
  static const API_ENDPOINT = "http://192.168.43.119:3000";

  static Future<List<Product>?> fetchProducts() async {
    final response = await http.get(Uri.parse('$API_ENDPOINT/products'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Product.fromJson(json)).toList();

    } else {
      throw Exception('Failed to load products');
    }
  }
}
