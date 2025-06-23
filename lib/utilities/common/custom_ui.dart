import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/utilities/utilities.dart';

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
      appBar: isBack
          ? AppBar(
              centerTitle: centreTitle,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(
                  Icons.keyboard_arrow_left_outlined,
                  size: 37,
                ),
              ),
              title: Text(
                title,
                style: AppStyles.getSemiBoldTextStyle(fontSize: 19, color: Colors.white),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: AppColors.baseColor,
            )
          : null,
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

      //  CustomScrollView(
      //   slivers: <Widget>[
      //     if (isBack)
      //       sliverAppBar ??
      //           SliverAppBar(
      //             backgroundColor: AppColors.baseColor,
      //             foregroundColor: Colors.white,
      //             expandedHeight: expandedHeight,
      //             actions: actions,
      //             leading: isBack
      //                 ? IconButton(
      //                     onPressed: () {
      //                       context.pop();
      //                     },
      //                     icon: const Icon(
      //                       Icons.keyboard_arrow_left_outlined,
      //                       size: 37,
      //                     ),
      //                   )
      //                 : const SizedBox(),
      //             pinned: isBack,

      //             iconTheme: const IconThemeData(color: Colors.white),
      //             // floating: true,

      //             flexibleSpace: flexibleSpaceBar,
      //             title: Text(
      //               title,
      //               style: AppStyles.getSemiBoldTextStyle(fontSize: 19, color: Colors.white),
      //             ),
      //           ),
      //     SliverList(
      //       delegate: SliverChildListDelegate(
      //         <Widget>[
      //           Stack(
      //             children: <Widget>[
      //               if (behindImage != null) behindImage!,
      //               Stack(
      //                 children: <Widget>[
      //                   Column(
      //                     // padding: EdgeInsets.zero,
      //                     // physics: const NeverScrollableScrollPhysics(),
      //                     // shrinkWrap: true,
      //                     // primary: false,
      //                     children: <Widget>[
      //                       SizedBox(height: gap ?? MediaQuery.sizeOf(context).height / 40),
      //                       ClipPath(
      //                         clipper: CustomContainer(),
      //                         child: Container(
      //                           color: Colors.white,
      //                           height: whitContainerHeight,
      //                           width: MediaQuery.sizeOf(context).width,
      //                           padding: padding ?? const EdgeInsets.all(24),
      //                           child: Column(
      //                             children: <Widget>[
      //                               const SizedBox(height: 30),
      //                               ...children,
      //                               if (bottomNavigationBar != null) const SizedBox(height: 100) else const SizedBox(height: 30)
      //                             ],
      //                           ),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                   if (topIcon != null) topIcon!
      //                 ],
      //               ),
      //             ],
      //           )
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
