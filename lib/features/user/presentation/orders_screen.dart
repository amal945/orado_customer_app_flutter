import 'package:flutter/material.dart';
import 'package:orado_customer/utilities/common/scaffold_builder.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  static const String route = 'orders';
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldBuilder(
      route: OrdersScreen.route,
      body: ListView(),
    );
  }
}
