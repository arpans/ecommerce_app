import 'dart:convert';

import 'package:ecommerce_app/utils/common_function.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class RegistrationRepository {
  final String _baseUrl = 'https://api.escuelajs.co/api/v1/users';

  Future<Map<String, dynamic>> doSignUp(
      String name, String email, String password) async {
    dynamic param = {
      "name": name,
      "email": email,
      "password": password,
      "avatar": "https://picsum.photos/800",
    };
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      Response response = await http.post(
        Uri.parse(_baseUrl),
        body: jsonEncode(param),
        headers: headers,
      );

      print("response ${jsonDecode(response.body)}");

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Registration Failed');
      }
    } catch (e) {
      print("error  $e");
      showToastMessage(ctx!, false, "Something went wrong!");
      return {};
    }
  }
}
