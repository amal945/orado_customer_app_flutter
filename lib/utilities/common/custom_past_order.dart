import 'package:flutter/material.dart';
import 'package:orado_customer/features/user/provider/user_provider.dart';
import 'package:orado_customer/utilities/colors.dart';
import 'package:orado_customer/utilities/styles.dart';
import 'package:provider/provider.dart';

import '../../features/user/model/past_order_model.dart';

class CustomPastOrder extends StatelessWidget {
  final Orders data;

  const CustomPastOrder({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
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
                  data.restaurant?.name ?? "N/A",
                  style: AppStyles.getBoldTextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    Text(data.orderStatus == "1" ? "Delivered" : "Canceled",
                        style: AppStyles.getRegularTextStyle(
                            color: Colors.green, fontSize: 12)),
                    SizedBox(width: 4),
                    Icon(
                        data.orderStatus == "1"
                            ? Icons.check_circle
                            : Icons.dangerous,
                        color:
                            data.orderStatus == "1" ? Colors.green : Colors.red,
                        size: 16),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(data.restaurant?.address ?? "",
                style: AppStyles.getMediumTextStyle(
                    color: Colors.grey[700], fontSize: 14)),
            const SizedBox(height: 4),
            Text("₹${data.totalAmount?.toInt().toString()}",
                style: AppStyles.getMediumTextStyle(
                    fontSize: 16, color: AppColors.baseColor)),
            const Divider(height: 20),
            Text(
                data.orderItems != null
                    ? data.orderItems!
                        .where((item) =>
                            item.name != null && item.quantity != null)
                        .map((item) => "${item.name} x${item.quantity}")
                        .join(', ')
                    : "",
                style: AppStyles.getMediumTextStyle(fontSize: 14)),
            const SizedBox(height: 6),
            Text(data.orderTime ?? "",
                style: AppStyles.getMediumTextStyle(
                    fontSize: 12, color: Colors.grey[600])),
            data.unavailableProducts != null &&
                    data.unavailableProducts!.isNotEmpty
                ? const Divider(height: 20)
                : SizedBox.shrink(),
            data.unavailableProducts != null &&
                    data.unavailableProducts!.isNotEmpty
                ? Text(
                    "Some item are not available!",
                    style: AppStyles.getBoldTextStyle(
                        fontSize: 12, color: Colors.red),
                  )
                : SizedBox.shrink(),
            data.unavailableProducts != null &&
                    data.unavailableProducts!.isNotEmpty
                ? Text(
                    data.unavailableProducts!
                        .map((e) => e.name ?? '')
                        .where((name) => name.isNotEmpty)
                        .join(', '), // or use '\n' or ' • ' or ' | '
                    style: AppStyles.getBoldTextStyle(
                        color: Colors.red, fontSize: 12),
                  )
                : SizedBox.shrink(),
            const Divider(height: 20),
            data.isReorderAvailable == "1"
                ? Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll<Color>(Colors.red),
                          ),
                          onPressed: () {
                            context
                                .read<UserProvider>()
                                .reOrder(context, data.orderId!);
                          },
                          child: Text("REORDER",
                              style: AppStyles.getBoldTextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              )),
                        ),
                      ),
                      // const SizedBox(width: 10),
                      // Expanded(
                      //   child: OutlinedButton(
                      //     style: OutlinedButton.styleFrom(
                      //       side: BorderSide(color: AppColors.baseColor),
                      //       foregroundColor: AppColors.baseColor,
                      //     ),
                      //     onPressed: () {},
                      //     child: Text("RATE ORDER",
                      //         style: AppStyles.getBoldTextStyle(
                      //             color: AppColors.baseColor, fontSize: 14)),
                      //   ),
                      // ),
                    ],
                  )
                : Text(
                    "${data.reorderUnavailableReason}",
                    style: AppStyles.getBoldTextStyle(
                        fontSize: 12, color: AppColors.baseColor),
                  )
          ],
        ),
      ),
    );
  }
}
