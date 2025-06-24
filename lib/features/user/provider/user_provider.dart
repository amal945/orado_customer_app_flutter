import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<String> _favourites = [];
  List<String> get favourites => _favourites;
  
  // UserModel? _userModel;
  // UserModel? get userModel => _userModel;

  putLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // getUserData(BuildContext context) async {
  //   putLoading(true);
  //   // var data = await APIServices().getUserDetails();
  //   // try {
  //   //   if (data['status'] == 'Success') {
  //   //     _userModel = UserModel.fromJson(data['data']);
  //   //   } else {
  //   //     showSnackBar(context: context, message: data['message'] ?? 'User not found', backgroundColor: Colors.red);
  //   //   }
  //   // } catch (e) {}
  //   // if (fcmToken == null) {
  //   //   fcmToken = await FirebaseMessaging.instance.getToken();
  //   //   APIServices().sentFCMToken(fcmToken ?? '');
  //   // }
  //   putLoading(false);
  // }

  void addFavourite(String item) {
    if (!_favourites.contains(item)) {
      _favourites.add(item);
      notifyListeners();
    }
  }

  void removeFavourite(String item) {
    _favourites.remove(item);
    notifyListeners();
  }
}
