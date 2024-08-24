import 'dart:convert';
import 'package:ecommerce_app/models/cart_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepository {
  final SharedPreferences sharedPreferences;
  static const String cartKey = 'cart_items';

  CartRepository({required this.sharedPreferences});

  Future<void> saveCartItems(List<CartItem> items) async {
    final String encodedData = jsonEncode(items.map((item) => item.toJson()).toList());
    await sharedPreferences.setString(cartKey, encodedData);
  }

  List<CartItem> loadCartItems() {
    final String? jsonString = sharedPreferences.getString(cartKey);
    if (jsonString != null) {
      List<dynamic> decodedData = jsonDecode(jsonString);
      return decodedData.map((item) => CartItem.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> clearCart() async {
    await sharedPreferences.remove(cartKey);
  }
}
