import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/location/presentation/address_screen.dart';
import 'package:orado_customer/features/location/presentation/map_screen.dart';
import 'package:orado_customer/utilities/utilities.dart';

import '../orado_icon_icons.dart';

class CustomSliverAppBar {
  SliverAppBar showSliverAppBar(BuildContext context, {String? address}) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      elevation: 10,
      pinned: true,
      backgroundColor: Colors.grey.shade100,
      surfaceTintColor: Colors.transparent,
      title: InkWell(
        // onTap: () => context.pushNamed(AppPaths.confirmDeliveryLocation),
        child: Row(
          children: <Widget>[
            const SizedBox(width: 10),
            Icon(OradoIcon.location_pin, color: AppColors.baseColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                address ?? 'lorem ipsum',
                style: AppStyles.getBoldTextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(onPressed: (){
              context.pushNamed(AddressScreen.route);
            },icon: Icon(OradoIcon.vector, color: AppColors.baseColor, size: 10)),
            const SizedBox(width: 20),
          ],
        ),
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: () {

          },
          child: Container(
            height: 60,
            width: 60,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/images/Rectangle 15.png',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
