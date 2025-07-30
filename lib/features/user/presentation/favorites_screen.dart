import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/merchants/presentation/merchant_detail_screen.dart';
import 'package:orado_customer/features/user/provider/user_provider.dart';
import 'package:orado_customer/utilities/colors.dart';
import 'package:orado_customer/utilities/common/custom_restaurant_tile.dart';
import 'package:orado_customer/utilities/common/food_tile_card_large.dart';
import 'package:orado_customer/utilities/common/loading_widget.dart';
import 'package:orado_customer/utilities/styles.dart';
import 'package:provider/provider.dart';

import '../../../utilities/common/scaffold_builder.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  static String route = 'favorites';

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 1));
      final provider = context.read<UserProvider>();
      if (mounted) {
         provider.fetchFavourites(context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldBuilder(
      route: FavoritesScreen.route,
      appBar: AppBar(
        title: Text(
          'Favourites',
          style:
              AppStyles.getBoldTextStyle(fontSize: 22, color: AppColors.yellow),
        ),
        backgroundColor: AppColors.baseColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.greycolor, size: 24),
          onPressed: () {
            context.goNamed('home');
          },
        ),
        iconTheme: IconThemeData(color: AppColors.greycolor),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {

          if(userProvider.isLoading){
            return BuildLoadingWidget(
                withCenter: true, color: AppColors.baseColor);
          }

          if (userProvider.favourites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No favourites yet',
                    style: AppStyles.getSemiBoldTextStyle(
                        fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: userProvider.favourites.length,
            itemBuilder: (context, index) {
              final item = userProvider.favourites[index];
              return CustomRestaurantTile(
                merchantId: item.id,
                image:item.images != null && item.images!.isNotEmpty ? item.images?.first : '',
                name: item.name,
              );
            },
          );
        },
      ),
    );
  }
}
