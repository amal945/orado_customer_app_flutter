import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:orado_customer/features/user/model/favourite_model.dart';
import 'package:orado_customer/features/user/model/past_order_model.dart';
import 'package:orado_customer/services/favourite_services.dart';
import 'package:orado_customer/services/order_service.dart';

import '../../../services/profile_services.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<FavouriteItem> _favourites = [];

  List<FavouriteItem> get favourites => _favourites;

  List<Orders> _pastOrder = [];

  List<Orders> get pastOrder => _pastOrder;

  void putLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    putLoading(true);
    final response = await OrderService.getAllOrders();

    if (response != null && response.data != null) {

      await Future.delayed(Duration(seconds: 2));
      _pastOrder.clear();
      _pastOrder.addAll(response.data?.orders ?? []);
    }
    putLoading(false);
  }

  Future<void> fetchFavourites() async {
    putLoading(true);
    try {
      await Future.delayed(Duration(seconds: 2));
      final response = await FavouriteServices.getFavourites();
      _favourites.clear();
      _favourites = response.data;
    } catch (e) {
      log("Error fetching favourites: $e");
    }
    putLoading(false);
  }

  Future<void> addFavourite(FavouriteItem item) async {
    try {
      if (item.id == null || isFavourite(item.id!)) return;
      await FavouriteServices.addFavourite(restaurantId: item.id!);
      _favourites.add(item);
      notifyListeners();
    } catch (e) {
      log("Error adding favourite: $e");
    }
  }

  Future<void> removeFavourite(String restaurantId) async {
    try {
      await FavouriteServices.removeFavourite(restaurantId: restaurantId);
      _favourites.removeWhere((fav) => fav.id == restaurantId);
      notifyListeners();
    } catch (e) {
      log("Error removing favourite: $e");
    }
  }

  bool isFavourite(String restaurantId) {
    return _favourites.any((fav) => fav.id == restaurantId);
  }
}
