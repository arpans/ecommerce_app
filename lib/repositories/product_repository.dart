import 'dart:convert';

import 'package:ecommerce_app/models/product.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  final String _baseUrl = 'https://fakestoreapi.com/products';

  // Fetch products by category
  Future<List<Product>> fetchProductsByCategory(String category) async {
    final response = await http.get(Uri.parse('$_baseUrl/category/$category'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map<Product>((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
