import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/auth/presentation/login/login.dart';
import 'package:orado_customer/features/auth/presentation/sign_up_screen.dart';

import '../../../utilities/common/custom_button.dart';
import '../../../utilities/common/custom_container.dart';
import '../../../utilities/utilities.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});
  static String route = 'get-started';

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  late PageController _pageController;
  final int totalPages = 3;
  int activePage = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    timer = Timer.periodic(
      const Duration(seconds: 3),
          (_) {
        if (!_pageController.hasClients) return;

        // Move to next page or loop back to first
        int nextPage = activePage + 1;
        if (nextPage >= totalPages) nextPage = 0;

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.sizeOf(context).height / 1.8,
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              allowImplicitScrolling: true,
              itemCount: totalPages,
              onPageChanged: (int page) {
                setState(() {
                  activePage = page;
                });
              },
              itemBuilder: (BuildContext context, int pagePosition) {
                return Image.asset(
                  fit: BoxFit.cover,
                  imageStrings[pagePosition],
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: CustomContainer(),
              child: Container(
                height: MediaQuery.sizeOf(context).height / 2,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: ListView(
                  children: <Widget>[
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        totalPages,
                            (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: slidingDots(
                            activePage == index ? AppColors.baseColor : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      activePage == 0
                          ? 'Get Your Favorite \nFood Delivered'
                          : activePage == 1
                          ? 'Speedy Safe \nHome Delivery'
                          : 'Look Good.\nFeel Good',
                      style: AppStyles.getBoldTextStyle(fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
                      child: CustomButton().showColouredButton(
                        onPressed: () => context.pushNamed(SignUpScreen.route),
                        label: 'Create an account',
                        backGroundColor: AppColors.baseColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.baseColor,
                        ),
                        onPressed: () => context.pushNamed(LoginScreen.route),
                        child: Text(
                          'Login',
                          style: AppStyles.getBoldTextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AnimatedContainer slidingDots(Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceInOut,
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

List<String> imageStrings = <String>[
  'assets/images/Group 6.png',
  'assets/images/Group 1.png',
  'assets/images/Group 5.png',
];
