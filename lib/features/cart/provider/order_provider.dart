import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orado_customer/services/order_service.dart';
import 'package:orado_customer/features/location/provider/location_provider.dart'; // Keep if used elsewhere, currently unused in this class
import 'package:orado_customer/utilities/common/custom_dialog.dart'; // Assuming you have this for loading/error dialogs
// Assuming you have AppStyles etc.

class PlaceOrderController extends ChangeNotifier {
  static Future<String?> placeOrder({
    // <--- Changed return type to Future<String?>
    required BuildContext context,
    required String cartId,
    required String addressId,
    required String paymentMethod,
    String? couponCode,
    String? instructions,
    int? tipAmount,
  }) async {
    try {
      // Show loading indicator (if you have one, or use a CustomDialogue().showLoadingDialogue(context);)
      // For this example, let's assume OrderService.placeOrder handles its own loading or you'll add it here.
      // If you have a global loading indicator, it would go here.

      final response = await OrderService.placeOrder(
        cartId: cartId,
        addressId: addressId,
        paymentMethod: paymentMethod,
        couponCode: couponCode,
        instructions: instructions,
        tipAmount: tipAmount,
      );

      if (response != null &&
          response.messageType == "success" &&
          response.orderId != null) {
        // <--- Added null check for orderId
        log("✅ Order placed! ID: ${response.orderId}");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order placed successfully")),
        );

        return response.orderId; // <--- Return the orderId on success
      } else {
        log("❌ Order failed.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // Use a SnackBar directly as per your original code
            content: Text(response?.message ??
                "Order failed"), // Use response.message if available
            backgroundColor: Colors.red,
          ),
        );
        return null; // <--- Return null on failure
      }
    } catch (e) {
      log("❌ Exception in placeOrder: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong: $e"),
          backgroundColor: Colors.red,
        ),
      );
      return null; // <--- Return null on exception
    }
  }
}
