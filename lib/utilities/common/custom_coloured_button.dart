import 'package:flutter/material.dart';
import 'package:orado_customer/utilities/common/loading_widget.dart';

import '../utilities.dart';

class CustomColouredButton extends StatelessWidget {
  const CustomColouredButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.backGroundColor,
    this.foreGroundColor = Colors.white,
    this.buttonHeight,
    this.loading = false,
  });
  final void Function()? onPressed;
  final String label;
  final Color? backGroundColor;
  final Color foreGroundColor;
  final double? buttonHeight;
  final bool loading;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.baseColor,
        foregroundColor: foreGroundColor,
        minimumSize: Size(MediaQuery.of(context).size.width, buttonHeight ?? 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        padding: const EdgeInsets.all(18.0),
      ),
      onPressed: onPressed,
      child: loading ? BuildLoadingWidget() : FittedBox(fit: BoxFit.scaleDown, child: Text(label, style: AppStyles.getBoldTextStyle(fontSize: 16))),
    );
  }
}
