import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/cart/presentation/cart_screen.dart';
import 'package:orado_customer/features/home/presentation/home_screen.dart';
import 'package:orado_customer/features/user/presentation/favorites_screen.dart';
import 'package:orado_customer/features/user/presentation/orders_screen.dart';

import '../orado_icon_icons.dart';
import '../utilities.dart';
import 'custom_container.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key, required this.currentRoute});

  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: CustomContainer(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.white,
                height: 90,
                child: Padding(
                  padding: const EdgeInsets.only(top: 17.0),
                  child: LayoutBuilder(builder: (context, constraints) {
                    // final AlignmentGeometry dotAlignment = getDotAlign(constraints);

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            getIconButton(context,
                                icon: currentRoute == Home.route
                                    ? OradoIcon.home_coloured
                                    : OradoIcon.home_outlined,
                                route: Home.route),
                            const SizedBox(width: 20),
                            getIconButton(context,
                                icon: currentRoute == OrdersScreen.route
                                    ? OradoIcon.orders
                                    : OradoIcon.orders_outlined,
                                route: OrdersScreen.route),
                            const SizedBox(width: 20),
                            getIconButton(context,
                                icon: currentRoute == FavoritesScreen.route
                                    ? Icons.favorite
                                    : Icons.favorite_border_outlined,
                                route: FavoritesScreen.route),
                            const SizedBox(width: 20),
                            getIconButton(context,
                                icon: currentRoute == CartScreen.route
                                    ? OradoIcon.cart
                                    : OradoIcon.cart,
                                route: CartScreen.route),
                          ],
                        ),
                        // Align(
                        //   alignment: dotAlignment,
                        //   child: Hero(
                        //     tag: 'bottom-align-dot',
                        //     child: CircleAvatar(
                        //       backgroundColor: AppColors.baseColor,
                        //       radius: 3.5,
                        //     ),
                        //   ),
                        // ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: GestureDetector(
          //     onTap: () {},
          //     child: CircleAvatar(
          //       radius: 30,
          //       backgroundColor: AppColors.baseColor,
          //       child: const Icon(Icons.wallet, color: Colors.white),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  IconButton getIconButton(BuildContext context,
      {required String route, required IconData icon}) {
    return IconButton(
      onPressed: () {
        if (route != currentRoute) {
          context.goNamed(route);
        }
      },
      icon: Icon(
        icon,
        size: 25,
        color:
            currentRoute == route ? AppColors.baseColor : Colors.grey.shade500,
      ),
    );
  }

  AlignmentGeometry getDotAlign(BoxConstraints constraints) {
    return switch (currentRoute) {
      Home.route => Alignment(-0.8, 0),
      OrdersScreen.route => Alignment(-0.266, 0),
      _ => Alignment.topLeft,
    };
  }
}
