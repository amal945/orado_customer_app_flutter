import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:orado_customer/features/cart/models/order_model.dart';
import 'package:orado_customer/features/location/provider/location_provider.dart';

class OrderService {
  static const String baseUrl =
      "https://forforntend-flutter.vercel.app/order/place-order-byaddressId";

  static Future<PlaceOrderResponseModel?> placeOrder({
    required String cartId,
    required String addressId,
    required String paymentMethod,
    String? couponCode,
    String? instructions,
    int? tipAmount,
  }) async {
    try {
      final token = await LocationProvider.getToken();
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "cartId": cartId,
          "addressId": addressId,
          "paymentMethod": paymentMethod,
          if (couponCode != null) "couponCode": couponCode,
          if (instructions != null) "instructions": instructions,
          if (tipAmount != null) "tipAmount": tipAmount,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return PlaceOrderResponseModel.fromJson(data);
      } else {
        log("Failed to place order: ${response.body}");
        return null;
      }
    } catch (e) {
      log("Exception in placeOrder: $e");
      return null;
    }
  }
}
