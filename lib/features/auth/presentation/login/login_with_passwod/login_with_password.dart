import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../../utilities/colors.dart';
import '../../../../../utilities/common/custom_container.dart';
import '../../../../../utilities/common/text_formfield.dart';
import '../../../../../utilities/strings.dart';
import '../../../../../utilities/styles.dart';
import '../../../provider/login_provider.dart';
import '../../get_started_screen.dart';
import '../../reset_password.dart';
import '../../sign_up_screen.dart';

class LoginWithPassword extends StatelessWidget {
  final LoginProvider provider;
  const LoginWithPassword({super.key,required this.provider});

  @override
  Widget build(BuildContext context) {
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
                  // height: MediaQuery.sizeOf(context).height / 1.,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 19.0, horizontal: 18),
                    child: Form(
                      key: provider.loginFormKey,
                      child: Column(
                        // physics: const NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          const SizedBox(height: 50),
                          BuildTextFormField(
                            inputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            validator: (String? text) =>
                                AppStrings.validateEmail(text),
                            controller: provider.emailController,
                            fillColor: AppColors.greycolor,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hint: 'Email',
                          ),
                          const SizedBox(height: 20),
                          BuildTextFormField(
                              controller: provider.passwordController,
                              fillColor: AppColors.greycolor,
                              // validator: (String? text) => AppStrings.validatePassword(text),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              obscureText: true,
                              hint: 'Password'),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () =>
                                context.pushNamed(ResetPasswordScreen.route),
                            style: TextButton.styleFrom(
                              splashFactory: NoSplash.splashFactory,
                              elevation: 0,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                              foregroundColor:
                                  const Color.fromARGB(96, 187, 184, 184),
                            ),
                            child: Text(
                              'Forgot password?',
                              style: AppStyles.getMediumTextStyle(
                                  fontSize: 14, color: Colors.black45),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.baseColor,
                                foregroundColor: AppColors.baseColor,
                                minimumSize:
                                    Size(MediaQuery.of(context).size.width, 55),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(17)),
                                padding: const EdgeInsets.all(18.0),
                              ),
                              onPressed: () {
                                provider.login(context);
                              },
                              child: provider.isLoading
                                  ? LoadingAnimationWidget.progressiveDots(
                                      color: Colors.white, size: 30)
                                  : Text("Login",
                                      style: AppStyles.getBoldTextStyle(
                                          fontSize: 16, color: Colors.white))),
                          const SizedBox(height: 25),
                          Align(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                context.pushNamed(SignUpScreen.route);
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: "Don't have an account ? ",
                                  style: AppStyles.getRegularTextStyle(
                                      fontSize: 14, color: Colors.black),
                                  children: <InlineSpan>[
                                    TextSpan(
                                        style: AppStyles.getBoldTextStyle(
                                            fontSize: 14,
                                            color: AppColors.baseColor),
                                        text: ' SignUp')
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 17),
                          Row(
                            children: <Widget>[
                              const Expanded(child: Divider()),
                              const SizedBox(width: 5),
                              Text('Or',
                                  style: AppStyles.getSemiBoldTextStyle(
                                      fontSize: 14)),
                              const SizedBox(width: 5),
                              const Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 17),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.baseColor),
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.baseColor,
                              minimumSize:
                                  Size(MediaQuery.of(context).size.width, 55),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              padding: const EdgeInsets.all(18.0),
                            ),
                            onPressed: () {
                              provider.toggleOtpOrPassword();
                            },
                            child: Text("Login With Phone",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: AppColors.baseColor)),
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
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
