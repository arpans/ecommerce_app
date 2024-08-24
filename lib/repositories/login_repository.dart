import 'dart:convert';

import 'package:ecommerce_app/utils/common_function.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class LoginRepository {
  final String _baseUrl = 'https://api.escuelajs.co/api/v1/auth/login';

  Future<Map<String, dynamic>> doLogin(String email, String password) async {
    dynamic param = {
      "email": email,
      "password": password,
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

      print("param ${jsonEncode(param)}");

      print("response ${jsonDecode(response.body)}");

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      }
    } catch (e) {
      print("error eeeee $e");
      showToastMessage(ctx!, false, "Something went wrong!");
      return {};
    }
  }
}
