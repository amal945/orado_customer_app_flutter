import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/auth/presentation/otp_screen.dart';
import 'package:orado_customer/features/auth/presentation/otp_screen.dart';
import 'package:orado_customer/features/cart/presentation/cart_screen.dart';
import 'package:orado_customer/features/cart/presentation/order_status_screen.dart';
import 'package:orado_customer/features/home/presentation/home_screen.dart';
import 'package:orado_customer/features/location/presentation/map_screen.dart';
import 'package:orado_customer/features/location/presentation/map_screen.dart';
import 'package:orado_customer/features/location/presentation/map_screen.dart';
import 'package:orado_customer/features/merchants/presentation/merchant_detail_screen.dart';
import 'package:orado_customer/features/merchants/presentation/merchant_listing_screen.dart';
import 'package:orado_customer/features/splash/presentation/splash_screen.dart';
import 'package:orado_customer/features/user/presentation/favorites_screen.dart';
import 'package:orado_customer/features/user/presentation/orders_screen.dart';
import '../features/auth/presentation/get_started_screen.dart';
import '../features/auth/presentation/login/login.dart';
import '../features/auth/presentation/login/otp_login/verify_otp_login.dart';
import '../features/auth/presentation/new_password.dart';
import '../features/auth/presentation/reset_password.dart';
import '../features/auth/presentation/sign_up_screen.dart';
import '../features/auth/presentation/login_with_phone_number_screen.dart';
import '../features/no_internet_page.dart';
import 'connectivity_service.dart';

import '../main.dart';

final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: '/',
      redirect: (context, state) {
        if (!connectivityService.isConnected.value &&
            state.fullPath != state.namedLocation(NoInternetPage.route)) {
          return NoInternetPage.route;
        } else if (connectivityService.isConnected.value &&
            state.fullPath == state.namedLocation(NoInternetPage.route)) {
          return '/'; // Redirect back to home when the internet is restored
        }
        if (state.fullPath == '/') return "/${SplashScreen.route}";

        return null;
      },
      // pageBuilder: (context, state) => getCustomTransition(state, SplashScreen()),
      routes: [
        GoRoute(
          path: NoInternetPage.route,
          name: NoInternetPage.route,
          pageBuilder: (context, state) =>
              getCustomTransition(state, const NoInternetPage()),
        ),
        GoRoute(
          path: SplashScreen.route,
          name: SplashScreen.route,
          pageBuilder: (context, state) =>
              getCustomTransition(state, const SplashScreen()),
        ),
        GoRoute(
          path: GetStartedScreen.route,
          name: GetStartedScreen.route,
          pageBuilder: (context, state) =>
              getCustomTransition(state, const GetStartedScreen()),
        ),
        GoRoute(
          path: LoginScreen.route,
          name: LoginScreen.route,
          pageBuilder: (context, state) =>
              getCustomTransition(state, const LoginScreen()),
        ),
        GoRoute(
          path: SignUpScreen.route,
          name: SignUpScreen.route,
          pageBuilder: (context, state) =>
              getCustomTransition(state, const SignUpScreen()),
        ),
        GoRoute(
          path: ResetPasswordScreen.route,
          name: ResetPasswordScreen.route,
          pageBuilder: (context, state) =>
              getCustomTransition(state, const ResetPasswordScreen()),
        ),
        GoRoute(
          path: OtpScreen.route,
          name: OtpScreen.route,
          pageBuilder: (context, state) =>
              getCustomTransition(state, const OtpScreen()),
        ),
        GoRoute(
          path: VerifyOtpLogin.route,
          name: VerifyOtpLogin.route,
          pageBuilder: (context, state) =>
              getCustomTransition(state, const VerifyOtpLogin()),
        ),
        GoRoute(
          path: NewPasswordScreen.route,
          name: NewPasswordScreen.route,
          pageBuilder: (context, state) =>
              getCustomTransition(state, const NewPasswordScreen()),
        ),
        GoRoute(
          path: LoginWithPhoneNumberScreen.route,
          name: LoginWithPhoneNumberScreen.route,
          pageBuilder: (context, state) =>
              getCustomTransition(state, const LoginWithPhoneNumberScreen()),
        ),
        GoRoute(
          path: Home.route,
          name: Home.route,
          pageBuilder: (context, state) =>
              getCustomTransition(state, const Home()),
        ),
        GoRoute(
          path: MapScreen.route,
          name: MapScreen.route,
          pageBuilder: (context, state) =>
              getCustomTransition(state, const MapScreen()),
        ),
        GoRoute(
          path: OrdersScreen.route,
          name: OrdersScreen.route,
          pageBuilder: (context, state) =>
              getCustomTransition(state, const OrdersScreen()),
        ),
        GoRoute(
          path: FavoritesScreen.route,
          name: FavoritesScreen.route,
          pageBuilder: (context, state) =>
              getCustomTransition(state, const FavoritesScreen()),
        ),
        GoRoute(
          path: CartScreen.route,
          name: CartScreen.route,
          pageBuilder: (context, state) =>
              getCustomTransition(state, const CartScreen()),
        ),
        GoRoute(
          path: OrderStatusScreen.route,
          name: OrderStatusScreen.route,
          pageBuilder: (context, state) =>
              getCustomTransition(state, const OrderStatusScreen()),
        ),
        GoRoute(
          path: MerchantListingScreen.route,
          name: MerchantListingScreen.route,
          pageBuilder: (context, state) {
            var data = state.uri.queryParameters;
            return getCustomTransition(
              state,
              MerchantListingScreen(
                  searchQuery: data['search_query'],
                  categoryId: data['categoryId'],
                  subCategoryId: data['subcategoryId'],
                  merchantId: data['merchantId']),
            );
          },
        ),
        GoRoute(
          path: MerchantDetailScreen.route,
          name: MerchantDetailScreen.route,
          pageBuilder: (context, state) {
            return getCustomTransition(state,
                MerchantDetailScreen(id: state.uri.queryParameters['id']));
          },
        ),
      ],
    ),
  ],
);

Page<dynamic> getCustomTransition(GoRouterState state, Widget child) {
  // if (Platform.isAndroid) {
  //   return MaterialPage(
  //     key: UniqueKey(),
  //     child: child,
  //   );
  // }
  if (Platform.isIOS) {
    return CupertinoPage(
      key: UniqueKey(),
      child: child,
    );
  }
  return CustomTransitionPage(
    key: UniqueKey(),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Change the opacity of the screen using a Curve based on the the animation's
      // value
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
        child: child,
      );
    },
  );
}
