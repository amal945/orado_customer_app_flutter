import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:orado_customer/features/merchants/models/menu_data_model.dart';
import 'package:orado_customer/features/merchants/models/product_model.dart';
import 'package:orado_customer/services/restaurant_services.dart';
import 'package:orado_customer/utilities/utilities.dart';
import 'package:provider/provider.dart';

import '../../../services/api_services.dart';
import '../../location/provider/location_provider.dart';
import '../models/merchant_detail_model.dart';
import '../models/merchant_model.dart';

class MerchantProvider extends ChangeNotifier {
  final APIServices _apiServices = APIServices();
  bool _isLoading = false;
  String _message = '';

  List<MerchantModel> merchants = [];
  MerchantDetailModel? _singleMerchant;
  Map<String, List<ProductModel>> _merchantProducts = {};
  List<MerchantDetailModel> merchantDetails = [];
  List<MenuItem> menuItems = [];
  List<MenuItem> filteredMenuItems = [];

  final TextEditingController searchController = TextEditingController();

  bool _isSearching = false;

  bool get isSearching => _isSearching;

  List<MenuItem> _originalMenuItems = [];
  String? activeFilter;

  void storeOriginalItems() {
    _originalMenuItems = List.from(menuItems);
  }

  void toggleFoodTypeFilter(String foodType) {
    if (activeFilter == foodType) {
      activeFilter = null;
      searchController.clear(); // Clear search when removing filter
    } else {
      activeFilter = foodType;
      searchController.clear(); // Clear search when applying new filter
    }
    menuItems = List.from(_originalMenuItems);

    if (activeFilter != null) {
      menuItems = menuItems
          .where((item) =>
              item.foodType?.toLowerCase() == activeFilter?.toLowerCase())
          .toList();
    }

    notifyListeners();
  }

  set isSearching(bool val) {
    _isSearching = val;
    notifyListeners();
  }

  Map<String, List<ProductModel>> get merchantProducts => _merchantProducts;

  bool get isLoading => _isLoading;

  String get message => _message;

  void putLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getMerchantDetails(
      {required String restaurantId, required BuildContext context}) async {
    putLoading(true);
    try {
      LatLng latlng = context.read<LocationProvider>().currentLocationLatLng!;
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
        storeOriginalItems(); // Store the original items
      }
    } catch (e) {
      log("$e");
    }
    putLoading(false);
  }

  void filterMenuItems(String query) {
    if (query.trim().isEmpty) {
      // When search is cleared, restore original items
      menuItems = List.from(_originalMenuItems);
      isSearching = false;
      // If there was an active filter, reapply it
      if (activeFilter != null) {
        menuItems = _originalMenuItems
            .where((item) =>
                item.foodType?.toLowerCase() == activeFilter?.toLowerCase())
            .toList();
      }
    } else {
      // Filter based on search query
      final filtered = _originalMenuItems
          .where((item) =>
              item.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();

      // If there's an active filter, apply it to the search results
      if (activeFilter != null) {
        menuItems = filtered
            .where((item) =>
                item.foodType?.toLowerCase() == activeFilter?.toLowerCase())
            .toList();
      } else {
        menuItems = filtered;
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
