import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/profile/provider/profile_provider.dart';
import 'package:orado_customer/utilities/common/custom_past_order.dart';
import 'package:orado_customer/utilities/utilities.dart';
import 'package:provider/provider.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  static const String route = 'order-history';

   final List<Map<String, dynamic>> orders = const [
    {
      "restaurantName": "Mirchi Restaurant",
      "location": "Sahebganj",
      "price": 195,
      "items": "Veg Chowmein (2)",
      "time": "June 10, 3:19 PM",
      "isDelivered": true,
    },
    {
      "restaurantName": "Mirchi Restaurant",
      "location": "Sahebganj",
      "price": 333,
      "items": "Veg Manchurian (1), Paneer Butter Masala (1)",
      "time": "June 5, 11:45 AM",
      "isDelivered": true,
    },
    {
      "restaurantName": "Desi Galli",
      "location": "Gautam Buddha Nagar",
      "price": 398,
      "items": "Butter Tandoori Roti (2), Paneer Do Pyaza (1)",
      "time": "May 29, 3:27 AM",
      "isDelivered": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders",
          style:
              AppStyles.getBoldTextStyle(fontSize: 22, color: AppColors.yellow),
        ),
        backgroundColor: AppColors.baseColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.greycolor, size: 24),
          onPressed: () {
            context.pop();
          },
        ),
        iconTheme: IconThemeData(color: AppColors.greycolor),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return CustomPastOrder(
            restaurantName: order["restaurantName"],
            location: order["location"],
            price: order["price"].toString(),
            items: order["items"],
            time: order["time"],
            isDelivered: order["isDelivered"],
          );
        },
      ),
    );
  }
}