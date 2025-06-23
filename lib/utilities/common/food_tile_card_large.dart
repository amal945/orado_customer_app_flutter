import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/merchants/presentation/merchant_detail_screen.dart';

import '../utilities.dart';

class FoodTileCardLarge extends StatelessWidget {
  const FoodTileCardLarge({
    super.key,
    this.image,
    this.name,
    this.distance,
    this.merchantId,
  });
  final String? merchantId;
  final String? image;
  final String? name;
  final String? distance;
  @override
  Widget build(BuildContext context) {
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
                      color: Colors.black.withValues(alpha: 0.3),
                      image: DecorationImage(image: CachedNetworkImageProvider(image ?? ''), fit: BoxFit.cover),
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.favorite_outline_outlined,
                                color: Colors.white70,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.white70,
                              )),
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
                            // TODO: Add rating here
                            // Row(
                            //   children: <Widget>[
                            //     Text(
                            //       (Random().nextDouble() * 4 + 1).toStringAsFixed(1),
                            //       style: AppStyles.getSemiBoldTextStyle(fontSize: 16, color: Colors.green.shade700),
                            //     ),
                            //     const SizedBox(width: 10),
                            //     Icon(
                            //       Icons.star,
                            //       size: 14,
                            //       color: Colors.green.shade700,
                            //     ),
                            //   ],
                            // )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(Icons.timer_sharp, size: 15),
                            const SizedBox(width: 10),
                            Text(
                              '22 mins . ${distance ?? 0} KM',
                              textAlign: TextAlign.center,
                              style: AppStyles.getMediumTextStyle(
                                fontSize: 15,
                                // fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        // TODO: Add offer here
                        // const SizedBox(height: 15),
                        // Row(
                        //   children: <Widget>[
                        //     Image.asset('assets/images/offer.png', height: 15),
                        //     const SizedBox(width: 10),
                        //     Text(
                        //       'Flat ${AppStrings.inrSymbol} 150 OFF above @300',
                        //       style: AppStyles.getMediumTextStyle(
                        //         fontSize: 13,
                        //         color: AppColors.baseColor,
                        //       ),
                        //     ),
                        //   ],
                        // )
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
