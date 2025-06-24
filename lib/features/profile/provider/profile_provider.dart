import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  String name = 'John Doe';
  String email = 'johndoe@email.com';
  String phone = '+1 234 567 890';
  String address = '123 Main Street, City, Country';
  String imageUrl = 'assets/images/profile.jpg';

  void updateUserInfo({
    String? newName,
    String? newEmail,
    String? newPhone,
    String? newAddress,
    String? newImageUrl,
  }) {
    if (newName != null) name = newName;
    if (newEmail != null) email = newEmail;
    if (newPhone != null) phone = newPhone;
    if (newAddress != null) address = newAddress;
    if (newImageUrl != null) imageUrl = newImageUrl;

    notifyListeners();
  }
}