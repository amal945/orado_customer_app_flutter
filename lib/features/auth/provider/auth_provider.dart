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

  login(BuildContext context, {required String email, required String password}) async {
    putLoading(true);
    try {
      var data = await APIServices().loginWithPassword(context, email: email, password: password);
      print(data);
      var userData = jwt.parseJwtPayLoad(data['detail']);
      token = data['detail'];

      setHeaders();
      // context.read<UserProvider>().getUserData(context);
      context.goNamed(Home.route);
      // } else {
      //   showSnackBar(context, message: data['message'], backgroundColor: Colors.red);
      // }
    } catch (e) {
      showSnackBar(context, message: APIServices.defaultError['message'], backgroundColor: Colors.red);
    }
    putLoading(false);
  }

  signUp(BuildContext context, {required Map form}) async {
    putLoading(true);
    try {
      print(form);
      var data = await APIServices().signUp(context, form: form);
      print(data);
      if (data['status'].toString().toLowerCase() == 'success') {
        token = data['token'];
        setHeaders();
        // context.read<UserProvider>().getUserData(context);
        context.goNamed(Home.route);
      } else {
        showSnackBar(context, message: data['message'], backgroundColor: Colors.red);
      }
    } catch (e) {
      showSnackBar(context, message: APIServices.defaultError['message'], backgroundColor: Colors.red);
    }
    putLoading(false);
  }

  // Future<(bool, String?)> newPassword(BuildContext context, {required String password, required String confirmPassword}) async {
  //   putLoading(true);
  //   var data = await APIServices().newPassword({"user_id": tempUserId, "password": password, "password_confirmation": confirmPassword});
  //   bool success = data['status'].toString().toLowerCase() == 'success';
  //   try {
  //     showSnackBar(context: context, message: data['message'], backgroundColor: success ? Colors.green : Colors.red);
  //     if (data['status'].toString().toLowerCase() == 'success') {
  //       if (data['token'] != null) {
  //         token = data['token'];
  //         setHeaders();
  //         context.read<UserProvider>().getUserData(context);
  //         context.goNamed(HomePage.route);
  //       } else {
  //         context.goNamed(LogIn.route);
  //       }
  //     }
  //   } catch (e) {}
  //   putLoading(false);
  //   return (success, (data['message'] ?? data['data']).toString());
  // }

  // Future<(bool, String?)> forgotPassword(BuildContext context, {required String email, bool isResend = false}) async {
  //   putLoading(true);
  //   var data = await APIServices().forgotPassword({"email": email});
  //   bool success = data['status'].toString().toLowerCase() == 'success';
  //   if (success && !isResend) context.pushNamed(OTPpage.route, queryParameters: {'email': email});
  //   try {
  //     showSnackBar(context: context, message: data['message'], backgroundColor: success ? Colors.green : Colors.red);
  //   } catch (e) {}
  //   putLoading(false);
  //   return (success, (data['message'] ?? data['data']).toString());
  // }

  // late int tempUserId;
  // Future<(bool, String?)> otpVerify(BuildContext context, {required String email, required String otp}) async {
  //   putLoading(true);
  //   var data = await APIServices().verifyOTP({"email": email, "otp": otp});
  //   bool success = data['status'].toString().toLowerCase() == 'success';
  //   if (success) {
  //     tempUserId = data['data']['id'];
  //     context.pushNamed(CreatePasswordPage.route);
  //   }
  //   try {
  //     showSnackBar(context: context, message: data['message'], backgroundColor: success ? Colors.green : Colors.red);
  //   } catch (e) {}
  //   putLoading(false);
  //   return (success, (data['message'] ?? data['data']).toString());
  // }

  // Future<(bool, String?)> resetPassword(BuildContext context, {required String password, required String confirmPassword}) async {
  //   putLoading(true);
  //   var data = await APIServices().resetPassword({"password": password, "password_confirmation": confirmPassword});
  //   bool success = data['status'].toString().toLowerCase() == 'success';
  //   // if (success) context.goNamed(LogIn.route);

  //   try {
  //     showSnackBar(context: context, message: data['message'], backgroundColor: success ? Colors.green : Colors.red);
  //   } catch (e) {}
  //   putLoading(false);
  //   return (success, (data['message'] ?? data['data']).toString());
  // }

  // deleteAccount({required String reason}) async {
  //   putLoading(true);
  //   var data = await APIServices().deleteAccount({"reason": reason});
  //   print(data);
  //   // try {
  //   bool success = data['status'].toString().toLowerCase() == 'success';

  //   showSnackBar(context: navigatorKey.currentContext, message: data['message'], backgroundColor: success ? Colors.green : Colors.red);
  //   if (success) {
  //     logout(navigatorKey.currentContext!);
  //   }
  //   // } catch (e) {
  //   //   print(e);
  //   // }
  //   putLoading(false);
  // }

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
