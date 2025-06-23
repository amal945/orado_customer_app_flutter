import 'package:flutter/material.dart';

import '../utilities.dart';

class FilteringOptions extends StatelessWidget {
  const FilteringOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          Card(
            elevation: 8,
            color: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.settings,
                    size: 14,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Sort',
                    style: AppStyles.getBoldTextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 8,
            color: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7),
              child: Center(
                child: Text(
                  'Nearest',
                  style: AppStyles.getBoldTextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 8,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7),
              child: Center(
                child: Text(
                  'Great Offer',
                  style: AppStyles.getBoldTextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 8,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7),
              child: Center(
                child: Text(
                  'Pure Veg',
                  style: AppStyles.getBoldTextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 8,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7),
              child: Center(
                child: Text(
                  'Non Veg',
                  style: AppStyles.getBoldTextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
