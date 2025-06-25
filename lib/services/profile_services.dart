import 'dart:convert';
import 'package:orado_customer/features/location/provider/location_provider.dart';
import 'package:orado_customer/features/profile/model/profile_model.dart';
import 'package:orado_customer/services/api_services.dart';
import 'package:orado_customer/utilities/urls.dart';
import 'package:http/http.dart' as http;

class ProfileServices {
  static Future<ProfileModel> fetchProfile() async {
    try {
      final token = await LocationProvider.getToken();


      final url = Uri.parse(Urls.userProfile);

      final response = await http.get(
        url,
        headers: {
          ...APIServices.headers,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final profile = ProfileModel.fromJson(json);
        return profile;
      } else {
        print('Failed to fetch profile. Status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception("Failed to fetch profile");
      }
    } catch (e) {
      print("Exception in fetchProfile: $e");
      rethrow;
    }
  }

  static Future<void> updateProfile(ProfileModel profile) async {
    try {
      final token = await LocationProvider.getToken();

      final url = Uri.parse(Urls.updateUserProfile);

      final response = await http.put(
        url,
        headers: {
          ...APIServices.headers,
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(profile.toMap()),
      );

      if (response.statusCode != 200) {
        print('Failed to update profile. Status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception("Failed to update profile");
      }
    } catch (e) {
      print("Exception in updateProfile: $e");
      rethrow;
    }
  }
}