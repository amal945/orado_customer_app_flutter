import 'package:flutter/material.dart';
import 'package:orado_customer/utilities/common/custom_coloured_button.dart';
import 'package:orado_customer/utilities/common/custom_outlined_button.dart';

import '../utilities.dart';

class CustomButton {
  Widget showColouredButton({
    final void Function()? onPressed,
    required final String label,
    final Color? backGroundColor,
    final Color? foreGroundColor,
    final double? buttonHeight,
    final bool loading = false,
  }) {
    return CustomColouredButton(
      label: label,
      onPressed: onPressed,
      backGroundColor: backGroundColor,
      buttonHeight: buttonHeight,
      foreGroundColor: foreGroundColor ?? Colors.white,
    );
  }

  Widget showOutlinedButton({
    final void Function()? onPressed,
    required final String label,
    final Color? backGroundColor,
    final Color? foreGroundColor,
    final double? buttonHeight,
  }) {
    return CustomOutLinedButton(
      label: label,
      onPressed: onPressed,
      backGroundColor: backGroundColor,
      buttonHeight: buttonHeight,
      foreGroundColor: foreGroundColor ?? AppColors.baseColor,
    );
  }
}
