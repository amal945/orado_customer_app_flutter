import 'package:flutter/material.dart';
import 'package:orado_customer/features/user/model/favourite_model.dart';
import 'package:orado_customer/services/favourite_services.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<FavouriteItem> _favourites = [];
  List<FavouriteItem> get favourites => _favourites;

  void putLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchFavourites() async {
    putLoading(true);
    try {
      final response = await FavouriteServices.getFavourites();
      _favourites = response.data;
      notifyListeners();
    } catch (e) {
      print("Error fetching favourites: $e");
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
      print("Error adding favourite: $e");
    }
  }

  Future<void> removeFavourite(String restaurantId) async {
    try {
      await FavouriteServices.removeFavourite(restaurantId: restaurantId);
      _favourites.removeWhere((fav) => fav.id == restaurantId);
      notifyListeners();
    } catch (e) {
      print("Error removing favourite: $e");
    }
  }

  bool isFavourite(String restaurantId) {
    return _favourites.any((fav) => fav.id == restaurantId);
  }
}