// ignore_for_file: use_named_constants, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/auth/presentation/get_started_screen.dart';
import 'package:orado_customer/features/auth/provider/auth_provider.dart';
import 'package:orado_customer/features/home/presentation/home_screen.dart';
import 'package:orado_customer/features/splash/provider/splash_provider.dart';
import 'package:orado_customer/features/user/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/api_services.dart';
import '../../../utilities/utilities.dart';
import '../../location/provider/location_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static String route = 'splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SplashProvider>(context);
    provider.getData(context);
    return Scaffold(
      backgroundColor: AppColors.baseColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Align(
            child: Container(
              padding: const EdgeInsets.only(bottom: 50),
              height: 500,
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  AnimatedAlign(
                      alignment: provider.logoAlignment,
                      duration: const Duration(milliseconds: 600),
                      child: SvgPicture.asset(
                        color: Colors.white,
                        'assets/images/logo.svg',
                      )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SvgPicture.asset(
                      height: 60,
                      color: Colors.white,
                      'assets/images/Logoname.svg',
                    ),
                  ),
                ],
              ),
            ),
          ),
          // const SizedBox(height: 30),
          FadeTransition(
              opacity: AnimationController(
                  duration: const Duration(milliseconds: 600), vsync: this)
                ..forward(),
              child: Image.asset('assets/images/hand.png')),
        ],
      ),
    );
  }
}
