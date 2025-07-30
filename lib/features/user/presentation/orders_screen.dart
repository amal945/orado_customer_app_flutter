import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/user/provider/user_provider.dart';
import 'package:orado_customer/utilities/common/loading_widget.dart';
import 'package:orado_customer/utilities/common/scaffold_builder.dart';
import 'package:orado_customer/utilities/placeholders.dart';
import 'package:provider/provider.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/common/custom_past_order.dart';
import '../../../utilities/styles.dart';
import '../../home/presentation/home_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  static const String route = 'orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 1));

      if (mounted) {
        final provider = context.read<UserProvider>();
        provider.fetchOrders(context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldBuilder(
      route: OrdersScreen.route,
      appBar: AppBar(
        title: Text(
          "Your Orders",
          style:
              AppStyles.getBoldTextStyle(fontSize: 22, color: AppColors.yellow),
        ),
        backgroundColor: AppColors.baseColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.greycolor, size: 24),
          onPressed: () {
            context.goNamed(Home.route);
          },
        ),
        iconTheme: IconThemeData(color: AppColors.greycolor),
      ),
      body: Consumer<UserProvider>(builder: (context, provider, _) {
        if (provider.isLoading) {
          return BuildLoadingWidget(
              withCenter: true, color: AppColors.baseColor);
        }

        if (provider.pastOrder.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.no_food,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No Orders yet',
                  style: AppStyles.getSemiBoldTextStyle(
                      fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }
        if (provider.isLoading) {
          return Center(
            child: BuildLoadingWidget(),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 80.0, top: 50),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: provider.pastOrder.length,
            itemBuilder: (context, index) {
              final order = provider.pastOrder[index];
              return CustomPastOrder(
                data: order,
              );
            },
          ),
        );
      }),
    );
  }
}
