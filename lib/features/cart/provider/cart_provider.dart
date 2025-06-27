import 'package:flutter/material.dart';
import 'package:orado_customer/services/cart_services.dart';

import '../../../utilities/debouncer.dart';
import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Products> _cartItems = [];

  List<Products> get cartItems => _cartItems;
  final _debouncers = <String, Debouncer>{}; // Keyed by productId

  putLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<void> getAllCart() async {
    var response = await CartServices.getAllCart();

    if (response.messageType == "success" &&
        response.data != null &&
        response.data?.products != null) {
      cartItems.clear();
      cartItems.addAll(response.data?.products ?? []);
      notifyListeners();
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

    _debouncers[productId]!.debounce(() {
      if (quantity <= 0) {
        if (existingIndex != -1) _cartItems.removeAt(existingIndex);
      } else if (existingIndex != -1) {
        final current = _cartItems[existingIndex];
        _cartItems[existingIndex] = current.copyWith(quantity: quantity);
      } else {
        _cartItems.add(Products(
          productId: productId,
          quantity: quantity,
          // fill in other fields if needed
        ));
      }

      notifyListeners();
      // Optionally make the real API call here
    });
  }
}
