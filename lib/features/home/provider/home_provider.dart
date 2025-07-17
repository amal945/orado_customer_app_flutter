import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:orado_customer/features/home/models/category_model.dart';
import 'package:orado_customer/features/home/models/home_model.dart';
import 'package:orado_customer/features/home/models/recommended_restaurant_model.dart';
import 'package:orado_customer/features/location/provider/location_provider.dart';
import 'package:orado_customer/services/api_services.dart';
import 'package:orado_customer/services/home_service.dart';
import 'package:orado_customer/services/order_service.dart';
import 'package:orado_customer/utilities/utilities.dart';
import 'package:provider/provider.dart';

import '../models/resturant_data_model.dart';

class HomeProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  HomeModel? _homeModel;

  List<RestaurantDataModel> restaurantData = [];

  List<Restaurant> restaurantList = [];

  List<Restaurant> filteredRestaurantList = [];

  bool isRecommendedAvailable = false;

  List<RecommendedRestaurant> recommendedRestaurants = [];

  HomeModel? get homeModel => _homeModel;

  LatLng? currentLocationLatLng;
  String? currentLocationAddress;

  _toggleLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<CategoryModel> categoriesData = [];

  Future<void> getHome(BuildContext context) async {
    try {
      _toggleLoading(true);
      if (context.read<LocationProvider>().currentLocationLatLng == null) {
        await context.read<LocationProvider>().getCurrentLocation(context);
      }
      var location =
          await context.read<LocationProvider>().currentLocationLatLng;

      if (location?.latitude != null &&
          location?.longitude != null &&
          location != null) {
        final latitude = location.latitude.toString();

        final longitude = location.longitude.toString();

        String tempLatitude = "9.995001";
        String tempLongitude = "76.29215";

        final response = await HomeService.getNearByCategories(
            latitude: tempLatitude, longitude: tempLongitude);

        if (response.messageType != null && response.messageType == "success") {
          categoriesData.clear();
          categoriesData.add(response);

          notifyListeners();
        }

        final restaurantResponse =
            await HomeService.getRestaurants(lat: tempLatitude, long: tempLongitude);

        if (restaurantResponse.messageType != null &&
            restaurantResponse.messageType == "success") {
          restaurantData.clear();
          restaurantData.add(restaurantResponse);
          restaurantList.clear();
          restaurantList.addAll(restaurantResponse.data!);
          filteredRestaurantList =
              List.from(restaurantList); // Initialize with all restaurants
          notifyListeners();
        }

        final recommendedRestaurantResponse =
            await HomeService.getRecommendedRestaurant(
                lat: tempLatitude, long: tempLongitude);

        if (recommendedRestaurantResponse.messageType != null &&
            recommendedRestaurantResponse.messageType == "success") {
          isRecommendedAvailable =
              recommendedRestaurantResponse.count! > 0 ? true : false;

          recommendedRestaurants.clear();
          recommendedRestaurants
              .addAll(recommendedRestaurantResponse.data ?? []);
          notifyListeners();
        }


        final activeOrderResponse = await OrderService.getActiveOrder();

        if(activeOrderResponse != null){

        }

      } else {
        showSnackBar(context,
            message: "Failed to Fetch Location", backgroundColor: Colors.red);
      }
    } catch (e) {
      showSnackBar(context, message: "$e", backgroundColor: Colors.red);
    }
    _toggleLoading(false);
  }

  void searchRestaurants(String query) {
    if (query.isEmpty) {
      filteredRestaurantList = List.from(restaurantList);
    } else {
      filteredRestaurantList = restaurantList.where((restaurant) {
        final nameMatch = (restaurant.shopName ?? '')
            .toLowerCase()
            .contains(query.toLowerCase());
        final foodMatch = (restaurant.availableFoods ?? []).any((food) =>
            (food.name ?? '').toLowerCase().contains(query.toLowerCase()) ||
            (food.foodType ?? '').toLowerCase().contains(query.toLowerCase()));
        return nameMatch || foodMatch;
      }).toList();
    }
    notifyListeners();
  }

  void clearState() {
    _homeModel = null;
    restaurantData.clear();
    restaurantList.clear();
    filteredRestaurantList.clear();
    recommendedRestaurants.clear();
    isRecommendedAvailable = false;
    categoriesData.clear();
    currentLocationLatLng = null;
    currentLocationAddress = null;
    notifyListeners();
  }
}
