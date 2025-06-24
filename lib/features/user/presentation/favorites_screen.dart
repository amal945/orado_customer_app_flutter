import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/merchants/presentation/merchant_detail_screen.dart';
import 'package:orado_customer/features/user/provider/user_provider.dart';
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
  Widget build(BuildContext context) {
    return ScaffoldBuilder(
      route: FavoritesScreen.route,
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return ListView.builder(
            itemCount: userProvider.favourites.length,
            itemBuilder: (context, index) {
              final item = userProvider.favourites[index];
              final isFavourite = userProvider.favourites.contains(item);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () {
                    context.pushNamed(MerchantDetailScreen.route, queryParameters: <String, String>{'id': item});
                  },
                  contentPadding: const EdgeInsets.all(8.0),
                  tileColor: Colors.black.withAlpha(30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.white70,
                    child: 
                    Text(
                      item[0].toUpperCase(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  title: Text(item),
                  trailing: IconButton(
                    onPressed: () {
                      if (isFavourite) {
                        userProvider.removeFavourite(item);
                      } else {
                        userProvider.addFavourite(item);
                      }
                    },
                    icon: Icon(
                      isFavourite
                          ? Icons.favorite
                          : Icons.favorite_outline_outlined,
                      color: isFavourite ? Colors.red : Colors.white70,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
