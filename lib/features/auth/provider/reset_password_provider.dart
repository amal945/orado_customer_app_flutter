import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/auth/presentation/login/login.dart';
import 'package:orado_customer/features/auth/presentation/new_password.dart';
import 'package:orado_customer/features/auth/presentation/otp_screen.dart';
import 'package:orado_customer/services/auth_service.dart';

import '../../../utilities/utilities.dart';

class ResetPasswordProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey();
  final GlobalKey<FormState> newPasswordFormKey = GlobalKey();

  final List<TextEditingController> otpControllers =
      List.generate(5, (_) => TextEditingController());

  toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<void> sendOtp(BuildContext context) async {
    toggleLoading();
    if (!resetPasswordFormKey.currentState!.validate()) {
      toggleLoading();
      return;
    }

    if (emailController.text.trim().isEmpty) {
      showSnackBar(context,
          message: "Email cannot be empty", backgroundColor: Colors.red);

      toggleLoading();
      return;
    }

    final email = emailController.text.trim();

    try {
      final response = await AuthService.sendOtpPassword(email: email);

      context.pushNamed(OtpScreen.route);

      showSnackBar(context,
          message: response.message ?? "",
          backgroundColor:
              response.messageType != "success" ? Colors.red : Colors.green);
    } catch (e) {
      log("Login Error: $e");
      showSnackBar(context, message: "$e", backgroundColor: Colors.red);
    }
    toggleLoading();
  }

  Future<void> verifyOtp(BuildContext context) async {
    toggleLoading();

    final email = emailController.text.trim();

    final otp = otpControllers.map((controller) => controller.text).join();

    if (otp.length < 5) {
      showSnackBar(context,
          message: "Invalid OTP", backgroundColor: Colors.red);
      return;
    }

    try {
      final response =
          await AuthService.verifyOtpPassword(email: email, otp: otp);

      if (response.messageType == "success") {
        context.goNamed(NewPasswordScreen.route);
      }

      showSnackBar(context,
          message: response.message ?? "",
          backgroundColor:
              response.messageType != "success" ? Colors.red : Colors.green);
    } catch (e) {
      log("Login Error: $e");
      showSnackBar(context, message: "$e", backgroundColor: Colors.red);
    }

    toggleLoading();
  }

  Future<void> resetPassword(BuildContext context) async {
    final password = newPasswordController.text.trim();

    final confirmPassword = confirmPasswordController.text.trim();

    if (!newPasswordFormKey.currentState!.validate()) {
      return;
    }

    if (password != confirmPassword) {
      showSnackBar(context,
          message: "Password does not match!", backgroundColor: Colors.red);

      return;
    }

    final email = emailController.text.trim();

    try {
      final response = await AuthService.resetPasswordEmail(
          password: password, email: email);

      if (response.messageType != null && response.messageType == "success") {
        context.goNamed(LoginScreen.route);
      }
      showSnackBar(context,
          message: response.message ?? "",
          backgroundColor:
              response.messageType != "success" ? Colors.red : Colors.green);
    } catch (e) {
      log("$e");
      showSnackBar(context, message: "$e", backgroundColor: Colors.red);
    }
  }
}
