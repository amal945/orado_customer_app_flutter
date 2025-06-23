import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:orado_customer/features/auth/presentation/get_started_screen.dart';
import 'package:orado_customer/features/auth/provider/login_provider.dart';
import '../../../../../utilities/colors.dart';
import '../../../../../utilities/common/custom_button.dart';
import '../../../../../utilities/common/custom_container.dart';
import '../../../../../utilities/common/text_formfield.dart';
import '../../../../../utilities/strings.dart';
import '../../../../../utilities/styles.dart';

class LoginWithOtp extends StatelessWidget {
  final LoginProvider provider;

  LoginWithOtp({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height / 1.5,
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
          ListView(
            children: <Widget>[
              SizedBox(height: MediaQuery.sizeOf(context).height / 2),
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
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 30),
                        BuildTextFormField(
                            controller: provider.phoneNumberController,
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
                        const SizedBox(height: 25),
                        CustomButton().showColouredButton(
                          label: ' Send Otp',
                          backGroundColor: AppColors.baseColor,
                          loading: provider.isLoading,
                          onPressed: provider.isLoading
                              ? null
                              : () {
                                  // // if (!formKey.currentState!.validate()) {
                                  // //   return;
                                  // // }
                                  // context.pushNamed(OtpLoginScreen.route);
                                  provider.sendLoginOtp(context);
                                },
                        ),
                        const SizedBox(height: 20),
                        Align(
                          child: InkWell(
                            onTap: () {
                              // context.pushNamed(AppPaths.ter);
                            },
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: 'By continuing, you agree to our\n ',
                                  style: AppStyles.getSemiBoldTextStyle(
                                      color: Colors.grey, fontSize: 14),
                                  children: const <InlineSpan>[
                                    TextSpan(
                                        style: TextStyle(
                                          color: Colors.grey,
                                          decoration: TextDecoration.underline,
                                        ),
                                        text: ' Terms of Services')
                                  ]),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
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
                          child: Text("Login With Password",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppColors.baseColor)),
                        ),
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
}
