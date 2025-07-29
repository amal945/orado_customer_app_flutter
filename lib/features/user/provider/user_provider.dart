import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:orado_customer/features/user/model/favourite_model.dart';
import 'package:orado_customer/features/user/model/past_order_model.dart';
import 'package:orado_customer/services/favourite_services.dart';
import 'package:orado_customer/services/order_service.dart';
import 'package:orado_customer/utilities/utilities.dart';

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
    try {
      final response = await OrderService.getAllOrders();
      if (response?.data != null) {
        _pastOrder = response!.data!.orders ?? [];
      }
    } catch (e) {
      log("Error fetching orders: $e");
    } finally {
      putLoading(false);
    }
  }

  Future<void> fetchFavourites() async {
    putLoading(true);
    try {
      final response = await FavouriteServices.getFavourites();
      _favourites = response.data;
    } catch (e) {
      log("Error fetching favourites: $e");
    } finally {
      putLoading(false);
    }
  }

  Future<void> addFavourite(FavouriteItem item, BuildContext context) async {
    if (item.id == null || isFavourite(item.id!)) return;

    try {
      final response =
          await FavouriteServices.addFavourite(restaurantId: item.id!);

      if (response?.messageType == "success") {
        _favourites.add(item);
        notifyListeners();

        showSnackBar(
          context,
          message: response?.message ?? "Added to favourites",
          backgroundColor: Colors.green,
        );
      } else {
        showSnackBar(
          context,
          message: response?.message ?? "Failed to add",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      log("Error adding favourite: $e");
    }
  }

  Future<void> removeFavourite(
      String restaurantId, BuildContext context) async {
    try {
      final response =
          await FavouriteServices.removeFavourite(restaurantId: restaurantId);

      if (response != null && response.messageType == "success") {
        _favourites.removeWhere((fav) => fav.id == restaurantId);
        showSnackBar(context,
            message: response?.message ?? "Removed from favourites",
            backgroundColor: Colors.red);
      }
      notifyListeners();
    } catch (e) {
      log("Error removing favourite: $e");
    }
  }

  bool isFavourite(String restaurantId) {
    return _favourites.any((fav) => fav.id == restaurantId);
  }
}
