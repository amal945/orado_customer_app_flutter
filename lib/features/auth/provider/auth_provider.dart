// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/auth/presentation/get_started_screen.dart';
import 'package:orado_customer/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orado_customer/utilities/jwt_decoder.dart' as jwt;
import '../../../services/api_services.dart';
import '../../../utilities/utilities.dart';
import '../../home/presentation/home_screen.dart';
import '../../user/provider/user_provider.dart';



class AuthProvider extends ChangeNotifier {
  AuthProvider({required this.token}) {
    log('provider : $token');
    if (token != null) setHeaders();
  }

  String? token;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // late UserModel _userModel;
  // UserModel get userModel => _userModel;

  putLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  setHeaders() async {
    log('setting headers ...');
    // APIServices.headers['Authorization'] = 'Bearer $token';
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // sharedPreferences.setString('token', token!);
  }


  logout(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // APIServices().revokeFCMToken();
    sharedPreferences.remove('token');
    APIServices.headers.remove('Authorization');
    token = null;
    MyApp.restartApp(context);
    context.goNamed(GetStartedScreen.route);
  }





}
