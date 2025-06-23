import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:orado_customer/features/auth/model/auth_response_%20model.dart';
import 'package:orado_customer/features/auth/model/global_response_model.dart';
import 'package:orado_customer/features/auth/model/login_response_model.dart';
import 'package:orado_customer/services/api_services.dart';
import 'package:orado_customer/utilities/urls.dart';

import '../features/home/models/sign_up_model.dart';

class AuthService {
  static Future<SignupModel> signUp(
      {required String name,
      required String email,
      required int phone,
      required String password}) async {
    try {
      final requestBody = jsonEncode({
        "name": name,
        "email": email,
        "phone": "+91$phone",
        "password": password,
      });
      final url = Uri.parse(Urls.register);
      final response =
          await http.post(url, body: requestBody, headers: APIServices.headers);

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);

        final data = SignupModel.fromJson(json);

        return data;
      } else {
        final json = jsonDecode(response.body);
        final data = SignupModel.fromJson(json);

        return data;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final requestBody = jsonEncode({
        "email": email,
        "password": password,
      });

      final url = Uri.parse(Urls.login);

      final response = await http.post(
        url,
        body: requestBody,
        headers: APIServices.headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final data = LoginResponseModel.fromJson(json);

        return data;
      } else {
        final json = jsonDecode(response.body);

        final data = LoginResponseModel.fromJson(json);

        return data;
      }
    } catch (e) {
      log("Login Error: $e");
      rethrow;
    }
  }

  static Future<AuthResponseModel> sendOtpPassword({
    required String email,
  }) async {
    try {
      final requestBody = jsonEncode({
        "email": email,
      });

      final url = Uri.parse(Urls.sendOtp);

      final response = await http.post(
        url,
        body: requestBody,
        headers: APIServices.headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final data = AuthResponseModel.fromJson(json);

        return data;
      } else {
        final json = jsonDecode(response.body);
        final data = AuthResponseModel.fromJson(json);

        return data;
      }
    } catch (e) {
      log("Login Error: $e");
      rethrow;
    }
  }

  static Future<AuthResponseModel> verifyOtpPassword({
    required String email,
    required String otp,
  }) async {
    try {
      final requestBody = jsonEncode({
        "otp": otp,
        "email": email,
      });

      final url = Uri.parse(Urls.verifyOtp);

      final response = await http.post(
        url,
        body: requestBody,
        headers: APIServices.headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final data = AuthResponseModel.fromJson(json);

        return data;
      } else {
        final json = jsonDecode(response.body);
        final data = AuthResponseModel.fromJson(json);

        return data;
      }
    } catch (e) {
      log("Login Error: $e");
      rethrow;
    }
  }

  static Future<GlobalResponseModel> resetPasswordEmail(
      {required String password, required String email}) async {
    try {
      final url = Uri.parse("${Urls.resetPassword}");

      final requestBody = jsonEncode({"newPassword": password, "email": email});

      final response = await http.post(
        url,
        body: requestBody,
        headers: APIServices.headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final data = GlobalResponseModel.fromJson(json);

        return data;
      } else {
        final json = jsonDecode(response.body);

        final data = GlobalResponseModel.fromJson(json);

        return data;
      }
    } catch (e) {
      log("$e");
      rethrow;
    }
  }

  static Future<GlobalResponseModel> sendLoginOtp(
      {required String phone}) async {
    try {
      final url = Uri.parse("${Urls.sendLoginOtp}");

      // final url =
      //     Uri.parse("https://forforntend-flutter.vercel.app/user/login-otp");

      final requestBody = jsonEncode({"phone": "+91$phone"});

      final response =
          await http.post(url, body: requestBody, headers: APIServices.headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final data = GlobalResponseModel.fromJson(json);

        return data;
      } else {
        final json = jsonDecode(response.body);

        final data = GlobalResponseModel.fromJson(json);

        return data;
      }
    } catch (e) {
      log("$e");
      rethrow;
    }
  }

  static Future<LoginResponseModel> verifyLoginOtp(
      {required String phone, required String otp}) async {
    try {
      final url = Uri.parse("${Urls.verifyLoginOtp}");

      final requestBody = jsonEncode({"phone": "+91$phone", "otp": otp});

      final response =
          await http.post(url, body: requestBody, headers: APIServices.headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final data = LoginResponseModel.fromJson(json);

        return data;
      } else {
        final json = jsonDecode(response.body);

        final data = LoginResponseModel.fromJson(json);

        return data;
      }
    } catch (e) {
      log("$e");
      rethrow;
    }
  }
}
