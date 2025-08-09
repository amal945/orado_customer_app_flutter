// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:orado_customer/features/auth/provider/reset_password_provider.dart';
import 'package:provider/provider.dart';

import '../../../utilities/common/custom_button.dart';
import '../../../utilities/common/custom_container.dart';
import '../../../utilities/common/text_formfield.dart';
import '../../../utilities/utilities.dart';
import 'get_started_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  static String route = 'reset-password';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ResetPasswordProvider>(context);
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
                image: AssetImage(imageStrings[0]),
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
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.sizeOf(context).height / 2.3),
                ClipPath(
                  clipper: CustomContainer(),
                  child: Container(
                    height: MediaQuery.sizeOf(context).height / 1.8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 19.0, horizontal: 18),
                      child: Form(
                        key: provider.resetPasswordFormKey,
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            const SizedBox(height: 10),
                            Align(
                              child: Text(
                                'Reset Password',
                                style: AppStyles.getBoldTextStyle(fontSize: 24),
                              ),
                            ),
                            const SizedBox(height: 25),
                            BuildTextFormField(
                                inputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                // validator: (String? text) {
                                //   if (text!.isEmpty) {
                                //     return 'Enter a valid email';
                                //   }
                                //   if (text.contains(AppStrings.emailRegex)) {
                                //     return 'Enter a valid email';
                                //   }
                                //
                                //   return null;
                                // },
                                validator: (String? text) =>
                                    AppStrings.validateEmail(text),
                                controller: provider.emailController,
                                fillColor: AppColors.greycolor,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hint: 'Email'),
                            const SizedBox(height: 35),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.baseColor,
                                  foregroundColor: AppColors.baseColor,

                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width, 55),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(17)),
                                  padding: const EdgeInsets.all(18.0),
                                ),
                                onPressed: () {
                                  provider.sendOtp(context);
                                },
                                child: provider.isLoading
                                    ? LoadingAnimationWidget.progressiveDots(
                                        color: Colors.white, size: 30)
                                    : Text("Reset",
                                        style: AppStyles.getBoldTextStyle(
                                            fontSize: 16,
                                            color: Colors.white))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
