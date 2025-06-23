import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:orado_customer/features/location/provider/location_provider.dart';
import 'package:orado_customer/services/api_services.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  CartModel _cart = CartModel(cartItems: []);
  CartModel get cart => _cart;

  putLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  getCart(BuildContext context) async {
    putLoading(true);
    var response = await APIServices().getCart(
      lat: context.read<LocationProvider>().currentLocationLatLng!.latitude,
      long: context.read<LocationProvider>().currentLocationLatLng!.longitude,
    );
    // try {
    log(response.body);
    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _cart = CartModel.fromJson(body);
    }
    // } catch (e) {
    //   print(e);
    // }
    putLoading(false);
  }

  addToCart(BuildContext context, {required String productId, required String merchantId, required int quantity}) async {
    putLoading(true);
    var response = await APIServices().addToCart(productId: productId, merchantId: merchantId, quantity: quantity);
    try {
      if (response.statusCode == 200) {
        getCart(context);
      }
    } catch (e) {
      print(e);
    }
    putLoading(false);
  }

  deleteFromCart(BuildContext context, {required String itemId}) async {
    putLoading(true);
    var response = await APIServices().deleteFromCart(itemId);
    try {
      if (response.statusCode == 200) {
        getCart(context);
      }
    } catch (e) {
      print(e);
    }

    putLoading(false);
  }

  updateItemInCart(BuildContext context, {required String itemId, required int quantity}) async {
    putLoading(true);
    var response = await APIServices().editCart(itemId: itemId, quantity: quantity);
    try {
      if (response.statusCode == 200) {
        getCart(context);
      }
    } catch (e) {
      print(e);
    }
    putLoading(false);
  }

  Future<bool> buyFromCart(BuildContext context, {required Map data}) async {
    putLoading(true);
    bool success = false;
    var response = await APIServices().buyFromCart(data);
    log(response.body);
    success = response.statusCode == 200;
    putLoading(false);
    return success;
  }
}
