import 'package:flutter/material.dart';
import 'package:orado_customer/features/profile/model/profile_model.dart';
import 'package:orado_customer/services/profile_services.dart';

class ProfileProvider with ChangeNotifier {
  String name = 'John Doe';
  String email = 'johndoe@email.com';
  String phone = '+1 234 567 890';
  String address = '123 Main Street, City, Country';
  String imageUrl = '';

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

  Future<void> fetchAndUpdateProfile() async {
    try {
      final profileModel = await ProfileServices.fetchProfile();
      if (profileModel != null) {
        final data = profileModel.data;
        String? fullAddress;
        if (data?.addresses != null && data!.addresses!.isNotEmpty) {
          final addr = data.addresses!.first;
          fullAddress = [
            addr.street,
            addr.city,
            addr.state,
            addr.zip,
          ].where((e) => e != null && e.isNotEmpty).join(', ');
        }
        updateUserInfo(
          newName: data?.name,
          newEmail: data?.email,
          newPhone: data?.phone,
          newAddress: fullAddress ?? '',
          newImageUrl: data?.profilePicture ?? '',
        );
      }
    } catch (e) {
      print("Error fetching profile: $e");
      rethrow;
    }
  }

  Future<void> updateProfileOnApi({
    required String name,
    required String email,
    required String phone,
    required String address,
  }) async {
    try {
      final profileModel = ProfileModel(
        data: ProfileData(
          name: name,
          email: email,
          phone: phone,
          addresses: [
            Addresses(
              street: address,
            ),
          ],
        ),
      );

      await ProfileServices.updateProfile(profileModel);

      updateUserInfo(
        newName: name,
        newEmail: email,
        newPhone: phone,
        newAddress: address,
      );
    } catch (e) {
      print("Error updating profile: $e");
      rethrow;
    }
  }
}
