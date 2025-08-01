import 'package:flutter/material.dart';
import 'package:ola_maps/ola_maps.dart';
import 'package:orado_customer/features/auth/provider/reset_password_provider.dart';
import 'package:orado_customer/features/auth/provider/sign_up_provider.dart';
import 'package:orado_customer/features/cart/provider/cart_provider.dart';
import 'package:orado_customer/features/home/provider/home_provider.dart';
import 'package:orado_customer/features/location/provider/location_provider.dart';
import 'package:orado_customer/features/location/provider/map_provider.dart';
import 'package:orado_customer/features/merchants/provider/merchant_provider.dart';
import 'package:orado_customer/features/profile/provider/profile_provider.dart';
import 'package:orado_customer/features/splash/provider/splash_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/provider/auth_provider.dart';
import 'features/auth/provider/login_provider.dart';
import 'features/home/provider/live_status_provider.dart';
import 'features/location/provider/address_provider.dart';
import 'features/notificaiton/notification.dart';
import 'features/profile/provider/loyalty_provider.dart';
import 'features/ticket/provider/ticket_provider.dart';
import 'features/user/provider/user_provider.dart';
import 'services/route_services.dart' as route;
import 'utilities/utilities.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final fcmHandler = FCMHandler();
  await fcmHandler
      .initialize();

  Olamaps.instance.initialize('iYm7HlH8BzRNDVcSlqyKf6IAgbZvU7OL9CyNwtlT');
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? mainToken = sharedPreferences.getString("token");
  // String? churchCode = sharedPreferences.getString('churchCode');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(token: mainToken)),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()?.restartApp();
  }
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();

  void restartApp() async {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: MaterialApp.router(
        title: 'ORADO',
        debugShowCheckedModeBanner: false,
        routerConfig: route.router,
        theme: ThemeData(
          cardTheme: const CardThemeData(
              surfaceTintColor: Colors.white, color: Colors.white),
          scaffoldBackgroundColor: Colors.grey.shade50,
          colorSchemeSeed: AppColors.baseColor,
          useMaterial3: true,
          progressIndicatorTheme:
              ProgressIndicatorThemeData(color: Colors.white),
        ),
        builder: (context, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<HomeProvider>(
                  create: (_) => HomeProvider()),
              ChangeNotifierProvider<UserProvider>(
                  create: (_) => UserProvider()),
              ChangeNotifierProvider<LocationProvider>(
                  create: (_) => LocationProvider()),
              ChangeNotifierProvider<MerchantProvider>(
                  create: (_) => MerchantProvider()),
              ChangeNotifierProvider<CartProvider>(
                  create: (_) => CartProvider()),
              ChangeNotifierProvider<SignUpProvider>(
                  create: (_) => SignUpProvider()),
              ChangeNotifierProvider<LoginProvider>(
                  create: (_) => LoginProvider()),
              ChangeNotifierProvider<ResetPasswordProvider>(
                  create: (_) => ResetPasswordProvider()),
              ChangeNotifierProvider<SplashProvider>(
                  create: (_) => SplashProvider()),
              ChangeNotifierProvider<MapScreenProvider>(
                  create: (_) => MapScreenProvider()),
              ChangeNotifierProvider<AddressProvider>(
                  create: (_) => AddressProvider()),
              ChangeNotifierProvider<ProfileProvider>(
                  create: (_) => ProfileProvider()),
              ChangeNotifierProvider<CartProvider>(
                  create: (_) => CartProvider()),
              ChangeNotifierProvider<ProfileProvider>(
                  create: (_) => ProfileProvider()),
              ChangeNotifierProvider<LoyaltyProvider>(
                  create: (_) => LoyaltyProvider()),
              ChangeNotifierProvider<LiveStatusProvider>(
                  create: (_) => LiveStatusProvider()),
              ChangeNotifierProvider<TicketProvider>(
                  create: (_) => TicketProvider()),
            ],
            child: child,
          );
        },
      ),
    );
  }
}
