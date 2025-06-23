import 'package:flutter/material.dart';

class BuildLoadingWidget extends StatelessWidget {
  const BuildLoadingWidget({super.key, this.color, this.size, this.withCenter = false});
  final double? size;
  final Color? color;
  final bool withCenter;
  @override
  Widget build(BuildContext context) {
    if (withCenter) {
      return Center(child: child);
    } else {
      return child;
    }
  }

  Widget get child => SizedBox(height: size ?? 20, width: size ?? 20, child: CircularProgressIndicator(color: color));
}
