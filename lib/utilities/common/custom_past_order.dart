import 'package:flutter/material.dart';
import 'package:orado_customer/utilities/colors.dart';
import 'package:orado_customer/utilities/styles.dart';

class CustomPastOrder extends StatelessWidget {
  final String restaurantName;
  final String location;
  final String price;
  final String items;
  final String time;
  final bool isDelivered;

  const CustomPastOrder({
    super.key,
    required this.restaurantName,
    required this.location,
    required this.price,
    required this.items,
    required this.time,
    required this.isDelivered,
  });

  @override
  Widget build(BuildContext context) {
    bool isDelivered = true;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  restaurantName,
                  style: AppStyles.getBoldTextStyle(fontSize: 16),
                ),
                if (isDelivered)
                  Row(
                    children: [
                      Text("Delivered",
                          style: AppStyles.getRegularTextStyle(
                              color: Colors.green, fontSize: 12)),
                      SizedBox(width: 4),
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(location,
                style: AppStyles.getMediumTextStyle(
                    color: Colors.grey[700], fontSize: 14)),
            const SizedBox(height: 4),
            Text("₹$price",
                style: AppStyles.getMediumTextStyle(
                    fontSize: 16, color: AppColors.baseColor)),
            const Divider(height: 20),
            Text(items, style: AppStyles.getMediumTextStyle(fontSize: 14)),
            const SizedBox(height: 6),
            Text(time,
                style: AppStyles.getMediumTextStyle(
                    fontSize: 12, color: Colors.grey[600])),
            const Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text("REORDER",
                        style: AppStyles.getBoldTextStyle(
                            color: AppColors.titleTextColor, fontSize: 14)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.baseColor),
                      foregroundColor: AppColors.baseColor,
                    ),
                    onPressed: () {},
                    child: Text("RATE ORDER",
                        style: AppStyles.getBoldTextStyle(
                            color: AppColors.baseColor, fontSize: 14)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
