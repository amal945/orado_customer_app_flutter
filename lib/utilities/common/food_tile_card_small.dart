import 'package:flutter/material.dart';

import '../utilities.dart';

class FoodTileCardSmall extends StatelessWidget {
  final String? image;
  final String? name;
  final String? distance;
  final String?time;
   FoodTileCardSmall({super.key, this.image,
     this.name,
     this.distance,
   this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      surfaceTintColor: Colors.white,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 135,
                width: 170,
                decoration:  BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(image!),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3),
                  child: Text(
                    name ?? "",
                    textAlign: TextAlign.center,
                    style: AppStyles.getSemiBoldTextStyle(fontSize: 17),
                  ),
                ),
              ),
              // SizedBox(height: 5),
              Align(
                child: Text(
                  distance ?? "",
                  textAlign: TextAlign.center,
                  style: AppStyles.getMediumTextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 3),
              Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.timer_sharp, size: 13),
                    const SizedBox(width: 10),
                    Text(
                      '$time mins',
                      textAlign: TextAlign.center,
                      style: AppStyles.getRegularTextStyle(fontSize: 14),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
