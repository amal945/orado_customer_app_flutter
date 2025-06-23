import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/utilities/common/custom_button.dart';
import 'package:orado_customer/utilities/utilities.dart';

class NoInternetPage extends StatelessWidget {
  static String route = '/no-internet';

  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You are offline. Please check your connection.',
                style: AppStyles.getRegularTextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomButton().showColouredButton(
                onPressed: () => context.go('/'),
                label: "Home",
              )
            ],
          ),
        ),
      ),
    );
  }
}
