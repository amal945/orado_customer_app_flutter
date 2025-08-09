import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/utilities/common/custom_bottom_nav.dart';

import '../../features/home/presentation/home_screen.dart';

class ScaffoldBuilder extends StatefulWidget {
  const ScaffoldBuilder({
    super.key,
    required this.route,
    required this.body,
    this.appBar,
  });

  final String route;
  final Widget body;
  final PreferredSizeWidget? appBar;

  @override
  State<ScaffoldBuilder> createState() => _ScaffoldBuilderState();
}
class _ScaffoldBuilderState extends State<ScaffoldBuilder> {
  @override
  Widget build(BuildContext context) {
    final bool hasManualNavBar = MediaQuery.of(context).viewPadding.bottom > 0;

    Widget content = widget.body;
    if (hasManualNavBar) {
      content = SafeArea(
        bottom: false, // still false if you handle it in CustomBottomNavBar
        child: widget.body,
      );
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (context.canPop()) {
          context.pop();
        } else {
          context.goNamed(Home.route);
        }
      },
      child: Scaffold(
        appBar: widget.appBar,
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: content,
        bottomNavigationBar: CustomBottomNavBar(currentRoute: widget.route),
      ),
    );
  }
}
