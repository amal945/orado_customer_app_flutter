import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/utilities/utilities.dart';

import '../../features/home/presentation/home_screen.dart';
import 'custom_container.dart';

class CustomUi extends StatelessWidget {
  const CustomUi({
    super.key,
    required this.title,
    this.gap,
    required this.children,
    this.isBack = true,
    this.backGround,
    this.padding,
    this.bottomNavigationBar,
    this.flexibleSpaceBar,
    this.sliverAppBar,
    this.whitContainerHeight,
    this.expandedHeight,
    this.actions,
    this.topIcon,
    this.centreTitle = false,
    this.physics,
  });
  final String title;
  final double? gap;
  final List<Widget> children;
  final bool isBack;
  final Widget? backGround;
  final EdgeInsets? padding;
  final Widget? bottomNavigationBar;
  final Widget? flexibleSpaceBar;
  final SliverAppBar? sliverAppBar;
  final double? whitContainerHeight;
  final double? expandedHeight;
  final List<Widget>? actions;
  final Widget? topIcon;
  final bool centreTitle;
  final ScrollPhysics? physics;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: physics ?? const AlwaysScrollableScrollPhysics(),
        child: Stack(
          children: <Widget>[
            // Container(
            //   width: double.infinity,
            //   height: MediaQuery.sizeOf(context).height * 0.25,
            //   decoration: BoxDecoration(color: AppColors.baseColor),
            // ),
            if (backGround != null) backGround!,
            Padding(
              padding: EdgeInsets.only(top: gap ?? 0),
              child: ClipPath(
                clipper: CustomContainer(),
                child: Container(
                  // constraints: BoxConstraints(
                  //   minHeight: MediaQuery.sizeOf(context).height - 70,
                  // ),
                  color: Colors.white,
                  // height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  padding: padding ?? const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
                  child: Column(
                    children: <Widget>[
                      // const SizedBox(height: 30),
                      ...children,
                      if (bottomNavigationBar != null) const SizedBox(height: 100) else const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
            if (topIcon != null)
              Positioned(
                top: 10,
                left: MediaQuery.sizeOf(context).width / 2.6,
                child: topIcon!,
              ),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
