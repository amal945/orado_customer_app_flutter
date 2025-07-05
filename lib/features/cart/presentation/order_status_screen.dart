import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orado_customer/features/cart/models/order_detail_summary_model.dart';
import 'package:orado_customer/features/cart/provider/order_summary_provider.dart';
import 'package:orado_customer/utilities/common/custom_ui.dart';
import 'package:orado_customer/utilities/orado_icon_icons.dart';
import 'package:orado_customer/utilities/utilities.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key, this.orderId});
  static String route = 'prepare_order';

  final String? orderId;

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  OrderSummaryModel? orderSummary;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.orderId != null && widget.orderId!.isNotEmpty) {
      loadOrderSummary();
    } else {
      log("No order ID provided.");
      setState(() => isLoading = false); // Skip loading if ID is null
    }
  }

  Future<void> loadOrderSummary() async {
    final result = await OrderSummaryController.getOrderSummary(
      context: context,
      orderId: widget.orderId!,
    );
    setState(() {
      orderSummary = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (widget.orderId == null || widget.orderId!.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            "No Order ID provided",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return buildOrderStatusUI(context);
  }

  Widget buildOrderStatusUI(BuildContext context) {
    final restaurantName =
        orderSummary?.order?.restaurant?.name ?? 'Restaurant';
    final deliveryName =
        orderSummary?.order?.customer?.name ?? 'Delivery Partner';
    final deliveryAddress =
        orderSummary?.order?.delivery?.address?.street ?? 'Delivery Address';
    final orderItem =
        orderSummary?.order?.items?.firstOrNull?.name ?? 'Order Item';

    return CustomUi(
      physics: const NeverScrollableScrollPhysics(),
      centreTitle: true,
      title: restaurantName,
      padding: EdgeInsets.zero,
      backGround: Align(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Text(
              'Order will be picked up shortly',
              style: AppStyles.getSemiBoldTextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            ActionChip(
              onPressed: () {},
              color: WidgetStateColor.resolveWith(
                (Set<WidgetState> states) =>
                    AppColors.baseColor.withValues(alpha: 0.6),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(color: Colors.transparent),
              ),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'On time',
                    style: AppStyles.getSemiBoldTextStyle(
                        fontSize: 12, color: Colors.white),
                  ),
                  const VerticalDivider(),
                  Text(
                    'Arriving in 22 minutes',
                    style: AppStyles.getSemiBoldTextStyle(
                        fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      gap: 100,
      children: [
        Stack(
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height,
              color: Colors.grey.shade300,
              child: DraggableScrollableSheet(
                initialChildSize: .6,
                maxChildSize: 0.9,
                minChildSize: .32,
                builder: (context, scrollController) {
                  return Container(
                    color: Colors.white,
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(14),
                      children: [
                        _buildDeliveryPartnerCard(deliveryName),
                        const SizedBox(height: 20),
                        _buildRestaurantCard(restaurantName, orderItem),
                        const SizedBox(height: 20),
                        _buildAddressCard(deliveryAddress),
                        const SizedBox(height: 20),
                        _buildSupportCard(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDeliveryPartnerCard(String deliveryName) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            dense: true,
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.yellow,
              child: Image.asset(
                'assets/images/delivery-man 1.png',
                height: 30,
                fit: BoxFit.contain,
              ),
            ),
            title: Text(
              deliveryName,
              style: AppStyles.getMediumTextStyle(fontSize: 14),
            ),
            subtitle: const Text('Your Delivery Partner'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    OradoIcon.message,
                    color: AppColors.baseColor,
                    size: 17,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    OradoIcon.phone,
                    color: AppColors.baseColor,
                    size: 17,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Thanks $deliveryName by leaving a tip',
                  style: AppStyles.getMediumTextStyle(fontSize: 14),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    ...[15, 20, 30].map((amount) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ActionChip(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          onPressed: () {},
                          label: Text(
                            '${AppStrings.inrSymbol}$amount',
                            style: AppStyles.getMediumTextStyle(fontSize: 13),
                          ),
                        ),
                      );
                    }),
                    ActionChip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      onPressed: () {},
                      label: Text(
                        'Other',
                        style: AppStyles.getMediumTextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantCard(String name, String item) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            dense: true,
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.yellow,
              backgroundImage: const AssetImage('assets/images/food.png'),
            ),
            title: Text(name),
            subtitle: const Text('Pavangad, Kozhikkode'),
          ),
          const Divider(),
          ListTile(
            dense: true,
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.yellow,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: SvgPicture.asset('assets/images/Vector.svg'),
              ),
            ),
            title: const Text('Order Details'),
            isThreeLine: true,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('1x $item'),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.baseColor,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {},
                  child: const Row(
                    children: [
                      Text('View Order Summary'),
                      Icon(Icons.keyboard_arrow_right_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            dense: true,
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: SvgPicture.asset(
                'assets/images/chef.svg',
                height: 30,
              ),
            ),
            title: const Text('Add Cooking Instructions'),
            trailing: Icon(
              Icons.keyboard_arrow_right_outlined,
              color: AppColors.baseColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(String address) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: SvgPicture.asset('assets/images/home.svg'),
        ),
        title: const Text('Delivery Address'),
        subtitle: Text(address),
        trailing: Icon(
          Icons.keyboard_arrow_right_outlined,
          color: AppColors.baseColor,
        ),
      ),
    );
  }

  Widget _buildSupportCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: SvgPicture.asset('assets/images/logo.svg'),
        ),
        title: const Text('Orado'),
        subtitle: const Text('Need help? Contact us'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                OradoIcon.message,
                color: AppColors.baseColor,
                size: 17,
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                OradoIcon.phone,
                color: AppColors.baseColor,
                size: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
