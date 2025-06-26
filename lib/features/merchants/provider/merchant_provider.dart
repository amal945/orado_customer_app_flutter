import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:orado_customer/features/merchants/models/menu_data_model.dart';
import 'package:orado_customer/features/merchants/models/product_model.dart';
import 'package:orado_customer/services/restaurant_services.dart';
import 'package:orado_customer/utilities/utilities.dart';

import '../../../services/api_services.dart';
import '../models/merchant_detail_model.dart';
import '../models/merchant_model.dart';

class MerchantProvider extends ChangeNotifier {
  final APIServices _apiServices = APIServices();
  bool _isLoading = false;
  String _message = '';

  List<MerchantModel> merchants = [];
  MerchantDetailModel? _singleMerchant;

  Map<String, List<ProductModel>> _merchantProducts = {};

  Map<String, List<ProductModel>> get merchantProducts => _merchantProducts;

  String? selectedMerchantId;
  String _shopStatus = ''; // Added missing _shopStatus for changeShopStatus

  bool get isLoading => _isLoading;

  String get message => _message;

  MerchantDetailModel? get singleMerchant => _singleMerchant;

  String get shopStatus => _shopStatus; // Getter for _shopStatus

  void putLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<MerchantDetailModel> merchantDetails = [];

  List<MenuItem> menuItems = [];

  Future<void> getMerchantDetails(
      {required String restaurantId, required LatLng latlng}) async {
    putLoading(true);
    try {
      final response = await RestaurantServices.getMerchantDetails(
          restaurantId: restaurantId, latlng: latlng);

      if (response.messageType == "success") {
        merchantDetails.clear();
        merchantDetails.add(response);
      }
    } catch (e) {
      log("$e");
    }
    putLoading(false);
  }

  Future<void> getMenu({required String restaurantId}) async {
    putLoading(true);
    try {
      final response = await RestaurantServices.getRestaurantMenu(
          restaurantId: restaurantId);

      if (response.messageType == "success") {
        menuItems.clear();
        final data =
            response.data.menu.expand((category) => category.items).toList();
        menuItems.addAll(data);
      }
    } catch (e) {}
    putLoading(false);
  }
}
