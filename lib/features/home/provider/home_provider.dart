import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:orado_customer/features/home/models/category_model.dart';
import 'package:orado_customer/features/home/models/home_model.dart';
import 'package:orado_customer/features/home/models/recommended_restaurant_model.dart';
import 'package:orado_customer/features/location/provider/location_provider.dart';
import 'package:orado_customer/services/home_service.dart';
import 'package:orado_customer/utilities/utilities.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/resturant_data_model.dart';

class HomeProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  HomeModel? _homeModel;
  HomeModel? get homeModel => _homeModel;

  List<RestaurantDataModel> restaurantData = [];
  List<Restaurant> restaurantList = [];
  List<Restaurant> filteredRestaurantList = [];

  List<CategoryModel> categoriesData = [];

  List<RecommendedRestaurant> recommendedRestaurants = [];
  bool isRecommendedAvailable = false;

  LatLng? currentLocationLatLng;
  String? currentLocationAddress;


  IO.Socket? _socket;
  bool _isSocketConnected = false;
  Map<String, dynamic> _liveDeliveryStatus = {};

  Map<String, dynamic> get liveDeliveryStatus => _liveDeliveryStatus;
  bool get isSocketConnected => _isSocketConnected;


  void _toggleLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  void initSocket({ String userType = "user"})async {

    final userId = await LocationProvider.getUserId();

    if (_socket != null && _socket!.connected) return;

    _socket = IO.io(
      'https://orado-backend.onrender.com', // ✅ Use actual backend
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      log("✅ Connected to socket server");

      _socket!.emit("join-room", {
        "userId": userId,
        "userType": userType,
      });

      _isSocketConnected = true;
      notifyListeners();
    });

    _socket!.on('test_order_status', (data) {
      log("📦 Delivery update received: $data");
      if (data is Map && data.containsKey("data")) {
        _liveDeliveryStatus = Map<String, dynamic>.from(data["data"]);
        notifyListeners();
      }
    });


    _socket!.onDisconnect((_) {
      log("⚠️ Socket disconnected");
      _isSocketConnected = false;
      notifyListeners();
    });

    _socket!.connect();
  }


  Future<void> _fetchLocation(BuildContext context) async {
    await context.read<LocationProvider>().getCurrentLocation(context);
    currentLocationLatLng = context.read<LocationProvider>().currentLocationLatLng;
  }

  Future<void> _fetchCategories(String latitude, String longitude) async {
    final response = await HomeService.getNearByCategories(latitude: latitude, longitude: longitude);
    if (response.messageType == "success") {
      categoriesData.clear();
      categoriesData.add(response);
    }
  }

  Future<void> _fetchRestaurants(String latitude, String longitude) async {
    final response = await HomeService.getRestaurants(lat: latitude, long: longitude);
    if (response.messageType == "success") {
      restaurantData.clear();
      restaurantData.add(response);
      restaurantList = List.from(response.data ?? []);
      filteredRestaurantList = List.from(restaurantList);
    }
  }

  Future<void> _fetchRecommendedRestaurants(String latitude, String longitude) async {
    final response = await HomeService.getRecommendedRestaurant(lat: latitude, long: longitude);
    if (response.messageType == "success") {
      isRecommendedAvailable = (response.count ?? 0) > 0;
      recommendedRestaurants = List.from(response.data ?? []);
    }
  }

  Future<void> _fetchAllData(String latitude, String longitude, {bool forceReload = false}) async {
    if (categoriesData.isEmpty || forceReload) await _fetchCategories(latitude, longitude);
    if (restaurantList.isEmpty || forceReload) await _fetchRestaurants(latitude, longitude);
    if (recommendedRestaurants.isEmpty || forceReload) await _fetchRecommendedRestaurants(latitude, longitude);
  }

  Future<void> refresh(BuildContext context) async {
    _toggleLoading(true);
    try {
      await _fetchLocation(context);
      if (currentLocationLatLng != null) {
        final lat = currentLocationLatLng!.latitude.toString();
        final long = currentLocationLatLng!.longitude.toString();
        await _fetchAllData(lat, long, forceReload: true);
      }
    } on SocketException {
      showSnackBar(context, message: "Please check your internet!", backgroundColor: Colors.red);
    } catch (e) {
      showSnackBar(context, message: "Some Error Occurred", backgroundColor: Colors.red);
    }
    _toggleLoading(false);
  }

  Future<void> getHome(BuildContext context) async {
    _toggleLoading(true);
    try {
      final oldLocation = currentLocationLatLng;
      if (oldLocation == null) await _fetchLocation(context);

      final newLocation = context.read<LocationProvider>().currentLocationLatLng;
      bool isLocationChanged = oldLocation != newLocation;

      if (newLocation != null) {
        currentLocationLatLng = newLocation;
        final lat = newLocation.latitude.toString();
        final long = newLocation.longitude.toString();
        await _fetchAllData(lat, long, forceReload: isLocationChanged);
      } else {
        showSnackBar(context, message: "Failed to Fetch Location", backgroundColor: Colors.red);
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
      final lowerQuery = query.toLowerCase();
      filteredRestaurantList = restaurantList.where((restaurant) {
        final shopName = restaurant.shopName?.toLowerCase() ?? '';
        final nameMatch = shopName.contains(lowerQuery);
        final foodMatch = (restaurant.availableFoods ?? []).any((food) =>
        (food.name ?? '').toLowerCase().contains(lowerQuery) ||
            (food.foodType ?? '').toLowerCase().contains(lowerQuery));
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

