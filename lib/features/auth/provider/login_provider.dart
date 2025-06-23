import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/auth/presentation/login/otp_login/verify_otp_login.dart';
import 'package:orado_customer/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/api_services.dart';
import '../../../utilities/utilities.dart';
import '../../home/presentation/home_screen.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey();
  final GlobalKey<FormState> newPasswordFormKey = GlobalKey();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final List<TextEditingController> otpControllers =
      List.generate(5, (_) => TextEditingController());

  bool loginWithPassword = false;

  bool otpSend = false;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  toggleOtpOrPassword() {
    loginWithPassword = !loginWithPassword;
    notifyListeners();
  }

  toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    toggleLoading();
    try {
      if (!loginFormKey.currentState!.validate()) {
        return;
      }
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final response =
          await AuthService.login(email: email, password: password);

      if (response.messageType != null && response.messageType == "success") {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("token", response.token!);
        preferences.setString("userId", response.userId!);
        emailController.clear();
        passwordController.clear();
        context.goNamed(Home.route);
      }
      showSnackBar(context,
          message: response.message ?? "Failed",
          backgroundColor:
              response.messageType != "success" ? Colors.red : Colors.green);
    } catch (e) {
      log("$e");
      showSnackBar(context,
          message: APIServices.defaultError['message'],
          backgroundColor: Colors.red);
    }
    toggleLoading();
  }

  Future<void> sendLoginOtp(BuildContext context) async {
    toggleLoading();
    final phone = phoneNumberController.text.trim();

    try {
      final response = await AuthService.sendLoginOtp(phone: phone);

      if (response.messageType != null && response.messageType == "success") {
        context.pushNamed(VerifyOtpLogin.route);
      }

      showSnackBar(context,
          message: response.message ?? "",
          backgroundColor:
              response.messageType == "success" ? Colors.green : Colors.red);
    } catch (e) {
      showSnackBar(context,
          message: APIServices.defaultError['message'],
          backgroundColor: Colors.red);
    }
    toggleLoading();
  }

  Future<void> verifyOtp(BuildContext context) async {
    try {
      final otp = otpControllers.map((controller) => controller.text).join();

      if (otp.length < 5) {
        showSnackBar(context,
            message: "Invalid OTP", backgroundColor: Colors.red);
        return;
      }

      final phone = phoneNumberController.text.trim();

      final response = await AuthService.verifyLoginOtp(phone: phone, otp: otp);

      if (response.messageType != null && response.messageType == "success") {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("token", response.token!);
        preferences.setString("userId", response.userId!);
        clearFields();
        context.goNamed(Home.route);
      }

      showSnackBar(context,
          message: response.message ?? "",
          backgroundColor:
              response.messageType == "success" ? Colors.green : Colors.red);
    } catch (e) {
      showSnackBar(context,
          message: APIServices.defaultError['message'],
          backgroundColor: Colors.red);
      log("$e");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    phoneNumberController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    for (final controller in otpControllers) {
      controller.clear();
    }
  }
}
