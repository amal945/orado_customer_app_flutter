// ignore_for_file: deprecated_member_use
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/auth/presentation/get_started_screen.dart';
import 'package:orado_customer/features/auth/presentation/login/login.dart';
import 'package:provider/provider.dart';
import '../../../utilities/common/custom_button.dart';
import '../../../utilities/common/custom_container.dart';
import '../../../utilities/common/text_formfield.dart';
import '../../../utilities/utilities.dart';
import '../provider/sign_up_provider.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  static String route = 'signup';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignUpProvider>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height / 3,
            decoration: BoxDecoration(
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
                        height: 70,
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
              SizedBox(height: MediaQuery.sizeOf(context).height / 4),
              ClipPath(
                clipper: CustomContainer(),
                child: Form(
                  key: provider.formKeySignUp,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                            vertical: 19.0, horizontal: 38)
                        .copyWith(top: 60),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: <Widget>[
                        BuildTextFormField(
                            controller: provider.nameController,
                            fillColor: AppColors.greycolor,
                            inputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            validator: (String? text) =>
                                AppStrings.validateName(text),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hint: 'Name'),
                        const SizedBox(height: 20),
                        BuildTextFormField(
                            controller: provider.phoneController,
                            inputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (String? text) =>
                                AppStrings.validatePhone(text),
                            fillColor: AppColors.greycolor,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hint: 'Phone number'),
                        const SizedBox(height: 20),
                        BuildTextFormField(
                            inputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            validator: (String? text) =>
                                AppStrings.validateEmail(text),
                            controller: provider.emailController,
                            fillColor: AppColors.greycolor,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hint: 'Email'),
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
                        BuildTextFormField(
                            obscureText: true,
                            controller: provider.confirmPasswordController,
                            fillColor: AppColors.greycolor,
                            // validator: (String? text) => AppStrings.validatePassword(text),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hint: 'Confirm Password'),
                        const SizedBox(height: 20),
                        Align(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              context.pushNamed(LoginScreen.route);
                            },
                            child: RichText(
                              text: TextSpan(
                                  text: 'Already have an account? ',
                                  style: AppStyles.getSemiBoldTextStyle(
                                      fontSize: 14,
                                      color: Colors.black.withAlpha(157)),
                                  children: <InlineSpan>[
                                    TextSpan(
                                        style: AppStyles.getSemiBoldTextStyle(
                                            fontSize: 14,
                                            color: AppColors.baseColor),
                                        text: ' Sign In')
                                  ]),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        CustomButton().showColouredButton(
                            label: 'Sign Up',
                            backGroundColor: AppColors.baseColor,
                            loading: provider.isLoading,
                            onPressed: () {
                              provider.signUp(context);
                            }),
                      ],
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

  Future<dynamic> showCountryCodeSelectionDialogue(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => const AlertDialog.adaptive(),
    );
  }
}
