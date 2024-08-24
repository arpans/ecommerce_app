import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryRepository {
  final String _baseUrl = 'https://fakestoreapi.com/products/categories';

  Future<List<String>> fetchCategories() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map<String>((category) => category.toString()).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
