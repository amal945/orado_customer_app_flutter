import 'package:flutter/material.dart';
import 'package:orado_customer/utilities/common/loading_widget.dart';

import '../utilities.dart';

class CustomOutLinedButton extends StatelessWidget {
  const CustomOutLinedButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.backGroundColor,
    this.foreGroundColor,
    this.buttonHeight,
    this.loading = false,
  });
  final void Function()? onPressed;
  final String label;
  final Color? backGroundColor;
  final Color? foreGroundColor;
  final double? buttonHeight;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColors.baseColor),
        backgroundColor: Colors.white,
        foregroundColor: foreGroundColor ?? AppColors.baseColor,
        minimumSize: Size(MediaQuery.of(context).size.width, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.all(18.0),
      ),
      onPressed: onPressed,
      child: loading ? BuildLoadingWidget() : Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
    );
  }
}
