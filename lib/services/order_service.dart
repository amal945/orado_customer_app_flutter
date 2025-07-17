import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:orado_customer/features/cart/models/order_model.dart';
import 'package:orado_customer/features/cart/models/payment_verification_model.dart';
import 'package:orado_customer/features/home/models/active_order_model.dart';
import 'package:orado_customer/features/location/provider/location_provider.dart';
import 'package:orado_customer/features/user/model/past_order_model.dart';
import 'package:orado_customer/utilities/urls.dart';

class OrderService {
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
        Uri.parse("${Urls.baserUrl}order/place-order-byaddressId"),
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

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {

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

  static Future<PaymentVerificationModel?> verifyPayment(
      {required String razorpayPaymentId,
      required String razorpayOrderId,
      required String signature,
      required String orderId}) async {
    try {
      final url = Uri.parse("${Urls.baserUrl}order/verify-payment");


      final token = await LocationProvider.getToken();


      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "razorpay_payment_id": razorpayPaymentId,
          "razorpay_order_id": razorpayOrderId,
          "razorpay_signature": signature,
          "orderId": orderId
        }),
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = PaymentVerificationModel.fromJson(json);

        return data;
      } else {

        return null;

      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<PastOrderModel?> getAllOrders() async {
    try {
      final url = Uri.parse("${Urls.baserUrl}order/customer/orders");

      final token = await LocationProvider.getToken();

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = PastOrderModel.fromJson(json);

        return data;
      } else {
        return null;
      }
    } catch (e) {
      log("$e");
    }
  }

  static Future<ActiveOrderModel?> getActiveOrder() async {
    try {
      final token = await LocationProvider.getToken();

      final url = Uri.parse("${Urls.baserUrl}order/active/status");

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = ActiveOrderModel.fromJson(json);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
