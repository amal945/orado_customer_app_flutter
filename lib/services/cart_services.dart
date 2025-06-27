import 'dart:convert';

import 'package:orado_customer/features/auth/model/global_response_model.dart';
import 'package:orado_customer/features/location/provider/location_provider.dart';
import 'package:orado_customer/utilities/urls.dart';
import 'package:http/http.dart' as http;

import '../features/cart/models/cart_model.dart';

class CartServices {
  static Future<GlobalResponseModel> addToCart(
      {required Map<String,dynamic> requestBody}) async {
    try {
      final url = Uri.parse("${Urls.baserUrl}cart/add");

      final token = await LocationProvider.getToken();

      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = GlobalResponseModel.fromJson(json);
        return data;
      } else {
        final json = jsonDecode(response.body);
        final data = GlobalResponseModel.fromJson(json);
        return data;
      }
    } catch (e) {
      rethrow;
    }
  }

 static Future<CartModel> getAllCart() async {
    try {
      final url = Uri.parse("${Urls.baserUrl}cart");
      final token = await LocationProvider.getToken();

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = CartModel.fromJson(json);
        return data;
      } else {
        final json = jsonDecode(response.body);
        final data = CartModel.fromJson(json);
        return data;
      }
    } catch (e) {
      rethrow;
    }
  }
}
