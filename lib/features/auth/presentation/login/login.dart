import 'package:flutter/material.dart';
import 'package:orado_customer/features/auth/presentation/login/otp_login/login_with_otp.dart';
import 'package:orado_customer/features/auth/presentation/login/login_with_passwod/login_with_password.dart';
import 'package:orado_customer/features/auth/provider/login_provider.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String route = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);
    if (provider.loginWithPassword) {
      return LoginWithPassword(provider: provider,);
    } else {
      return LoginWithOtp(provider: provider,);
    }
  }
}
