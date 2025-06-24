import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/merchants/presentation/merchant_detail_screen.dart';
import 'package:orado_customer/features/user/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../utilities.dart';

class FoodTileCardLarge extends StatelessWidget {
  const FoodTileCardLarge({
    super.key,
    this.image,
    this.name,
    this.distance,
    this.merchantId,
    this.productName,
  });
  final String? merchantId;
  final String? image;
  final String? name;
  final String? distance;
  final String? productName;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isFavourite = userProvider.favourites.contains(name);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(MerchantDetailScreen.route, queryParameters: <String, String>{'id': merchantId!});
        },
        child: Card(
          elevation: 4,
          surfaceTintColor: Colors.white,
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: Colors.black.withAlpha(30),
                      image: DecorationImage(image: CachedNetworkImageProvider(image ?? ''), fit: BoxFit.cover),
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              if (isFavourite) {
                                userProvider.removeFavourite(name!);
                              } else {
                                userProvider.addFavourite(name!);
                              }
                            },
                            icon: Icon(
                              isFavourite ? Icons.favorite : Icons.favorite_outline_outlined,
                              color: isFavourite ? Colors.red : Colors.white70,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              name!,
                              textAlign: TextAlign.center,
                              style: AppStyles.getSemiBoldTextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            const Icon(Icons.timer_sharp, size: 15),
                            const SizedBox(width: 10),
                            Text(
                              '22 mins . ${distance ?? 0} KM',
                              textAlign: TextAlign.center,
                              style: AppStyles.getMediumTextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}