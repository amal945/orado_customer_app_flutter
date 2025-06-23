import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/auth/presentation/get_started_screen.dart';
import 'package:provider/provider.dart';

import '../../../../../utilities/colors.dart';
import '../../../../../utilities/common/custom_button.dart';
import '../../../../../utilities/common/custom_container.dart';
import '../../../../../utilities/styles.dart';
import '../../../provider/login_provider.dart';
import '../login.dart';

class VerifyOtpLogin extends StatelessWidget {
  const VerifyOtpLogin({super.key});

  static String route = 'verify-otp-login-screen';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height / 2,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.vertical(bottom: Radius.circular(80)),
              image: DecorationImage(
                image: AssetImage(imageStrings[1]),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.baseColor.withOpacity(0.4),
                    ),
                  ),
                ),
                Align(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        color: Colors.white,
                        'assets/images/logo.svg',
                        height: 100,
                      ),
                      const SizedBox(height: 20),
                      SvgPicture.asset(
                          color: Colors.white,
                          height: 50,
                          'assets/images/Logoname.svg'),
                    ],
                  ),
                )
              ],
            ),
          ),
          ListView(
            children: <Widget>[
              SizedBox(height: MediaQuery.sizeOf(context).height / 2.6),
              ClipPath(
                clipper: CustomContainer(),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  // height: MediaQuery.sizeOf(context).height / 1.,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 50),
                      Text(
                        'We have sent an OTP to\n+91${provider.phoneNumberController.text.trim()}',
                        style: AppStyles.getBoldTextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      OtpFieldSection(
                        provider: provider,
                      ),
                      const SizedBox(height: 30),
                      CustomButton().showColouredButton(
                        label: ' Verify',
                        backGroundColor: AppColors.baseColor,
                        loading: provider.isLoading,
                        onPressed: provider.isLoading
                            ? null
                            : () {
                               provider.verifyOtp(context);
                              },
                      ),
                      Text(
                        'Check text message for your OTP',
                        style: AppStyles.getSemiBoldTextStyle(
                            fontSize: 14, color: AppColors.baseColor),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        child: InkWell(
                          onTap: () {
                            // context.pushNamed(AppPaths.ter);
                          },
                          child: RichText(
                            text: TextSpan(
                                text: "Didn't get the OTP ? ",
                                style: AppStyles.getSemiBoldTextStyle(
                                    fontSize: 14, color: Colors.black),
                                children: const <InlineSpan>[
                                  TextSpan(
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      text: ' Resend SMS in 15s')
                                ]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(LoginScreen.route);
                        },
                        child: Text(
                          'Go back to login method',
                          style: AppStyles.getBoldTextStyle(
                              fontSize: 14, color: AppColors.baseColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OtpFieldSection extends StatelessWidget {
  LoginProvider provider;

  OtpFieldSection({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (index) {
          return Container(
            height: 70,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: TextField(
                controller: provider.otpControllers[index],
                onChanged: (value) {
                  if (value.length == 1 && index < 4) {
                    FocusScope.of(context).nextFocus();
                  } else if (value.isEmpty && index > 0) {
                    FocusScope.of(context).previousFocus();
                  }
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
