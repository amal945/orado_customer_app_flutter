import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/auth/presentation/login/login.dart';
import 'package:orado_customer/services/auth_service.dart';
import 'package:orado_customer/utilities/utilities.dart';
import '../../../services/api_services.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/styles.dart';

class SignUpProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  GlobalKey<FormState> formKeySignUp = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> signUp(BuildContext context) async {
    toggleLoading();
    if (!formKeySignUp.currentState!.validate()) {
      return;
    }

    if (phoneController.text.trim().length < 10) {
      showSnackBar(context,
          message: "Phone number must have 10 digits",
          backgroundColor: Colors.red);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.baseColor,
          content: Text(
            "Password doesn't match",
            style: AppStyles.getSemiBoldTextStyle(
                fontSize: 15, color: Colors.white),
          ),
        ),
      );
      return;
    }
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = int.parse(phoneController.text.trim());
    final password = passwordController.text.trim();

    try {
      final response = await AuthService.signUp(
          name: name, email: email, phone: phone, password: password);

      if (response != null && response.messageType == "success") {
        showSnackBar(context,
            message: response.message!, backgroundColor: Colors.green);
        context.pushNamed(LoginScreen.route);
      } else {
        showSnackBar(context,
            message: response.message!, backgroundColor: Colors.red);
      }
    } catch (e) {
     log("$e");
      showSnackBar(context,
          message: APIServices.defaultError['message'],
          backgroundColor: Colors.red);
    }

    toggleLoading();
  }
}
