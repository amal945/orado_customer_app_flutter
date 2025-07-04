import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:orado_customer/services/cart_services.dart'; // Ensure this path is correct
import '../../../utilities/debouncer.dart';
import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Products> _cartItems = [];
  List<Products> get cartItems => _cartItems;

  Data? _cartData;
  Data? get cartData => _cartData;

  final _debouncers = <String, Debouncer>{};

  void putLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<void> getAllCart() async {
    putLoading(true);
    try {
      var response = await CartServices.getAllCart();
      putLoading(false);

      final products = response.data?.products;

      if (response.messageType == "success" &&
          response.data != null &&
          products != null &&
          products.isNotEmpty) {
        _cartItems.clear();
        _cartItems.addAll(products);
        _cartData = response.data;
        notifyListeners();
        log("Cart loaded successfully with ${products.length} items.");
      } else if (products == null || products.isEmpty) {
        // Cart is valid but empty
        _cartItems.clear();
        _cartData = response.data; // can still hold other info like totals = 0
        notifyListeners();
        log("Cart is empty");
      } else {
        // Unexpected failure or unknown response
        _cartItems.clear();
        _cartData = null;
        notifyListeners();
        log("Failed to load cart: ${response.message}");
      }
    } catch (e) {
      putLoading(false);
      _cartItems.clear();
      _cartData = null;
      notifyListeners();
      log("Error fetching cart: $e");
    }
  }

  void addToCart({
    required String restaurantId,
    required String productId,
    required int quantity,
  }) {
    final existingIndex =
        _cartItems.indexWhere((item) => item.productId == productId);

    if (!_debouncers.containsKey(productId)) {
      _debouncers[productId] =
          Debouncer(delay: const Duration(milliseconds: 900));
    }

    // Immediately update the UI for responsiveness
    if (quantity <= 0) {
      if (existingIndex != -1) _cartItems.removeAt(existingIndex);
    } else if (existingIndex != -1) {
      final current = _cartItems[existingIndex];
      _cartItems[existingIndex] = current.copyWith(quantity: quantity);
    } else {
      _cartItems.add(Products(
        productId: productId,
        quantity: quantity,
      ));
    }
    notifyListeners();

    _debouncers[productId]!.debounce(() async {
      log("Debounced API call for product $productId with quantity $quantity initiated.");
      log("  Restaurant ID: $restaurantId");
      log("  Product ID: $productId");
      log("  Quantity: $quantity");

      try {
        final response = await CartServices.addToCart(requestBody: {
          "restaurantId": restaurantId,
          "productId": productId,
          "quantity": quantity,
        });
        log("Add to cart API response: ${response.message}");
      } catch (e) {
        log("Error in addToCart service: $e");
      }

      await getAllCart();
      log("Debounced API call for product $productId with quantity $quantity completed (and cart refreshed).");
    });
  }
}
