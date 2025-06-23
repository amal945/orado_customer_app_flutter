// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/auth/presentation/get_started_screen.dart';
import 'package:orado_customer/features/auth/presentation/otp_screen.dart';

import '../../../utilities/common/custom_button.dart';
import '../../../utilities/common/custom_container.dart';
import '../../../utilities/common/text_formfield.dart';
import '../../../utilities/utilities.dart';

class LoginWithPhoneNumberScreen extends StatelessWidget {
  const LoginWithPhoneNumberScreen({super.key});
  static String route = 'login-with-phone';
  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneNumberController = TextEditingController();
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
                      SvgPicture.asset(color: Colors.white, height: 50, 'assets/images/Logoname.svg'),
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
                    padding: const EdgeInsets.symmetric(vertical: 19.0, horizontal: 18),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 30),
                        BuildTextFormField(
                            // prefix: BlocProvider<CountryCodeSelectionCubit>(
                            //   create: (BuildContext context) => codeSelectionCubit,
                            //   child: BlocConsumer<CountryCodeSelectionCubit, CountryCodeSelectionState>(
                            //     bloc: codeSelectionCubit,
                            //     listener: (BuildContext context, CountryCodeSelectionState state) {},
                            //     builder: (BuildContext context, CountryCodeSelectionState state) {
                            //       if (state is CountryCodeSelectionInitialState) {
                            //         return CountryCodeWidget(code: state.code, countryCodeCubt: codeSelectionCubit);
                            //       } else if (state is CountryCodeSelectionSuccessState) {
                            //         return CountryCodeWidget(code: state.code, countryCodeCubt: codeSelectionCubit);
                            //       } else {
                            //         return CountryCodeWidget(code: '', countryCodeCubt: codeSelectionCubit);
                            //       }
                            //     },
                            //   ),
                            // ),
                            controller: phoneNumberController,
                            inputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            validator: (String? text) => AppStrings.validatePhone(text),
                            fillColor: AppColors.greycolor,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hint: 'Phone number'),
                        const SizedBox(height: 25),
                        Align(
                          child: InkWell(
                            onTap: () {
                              // context.pushNamed(AppPaths.ter);
                            },
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: 'By continuing, you agree to our\n ',
                                  style: AppStyles.getSemiBoldTextStyle(color: Colors.grey, fontSize: 14),
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
                        CustomButton().showColouredButton(
                          label: ' Continue',
                          backGroundColor: AppColors.baseColor,
                          onPressed: () {
                            // if (!formKey.currentState!.validate()) {
                            //   return;
                            // }
                            context.pushNamed(OtpScreen.route);
                          },
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
