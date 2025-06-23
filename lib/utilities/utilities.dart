import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'utilities.dart';

export 'colors.dart';
export 'date_utils.dart';
export 'enums.dart';
export 'string_utils.dart';
export 'strings.dart';
export 'styles.dart';
export 'themes.dart';

String olaKey = 'iYm7HlH8BzRNDVcSlqyKf6IAgbZvU7OL9CyNwtlT';
String googleMapApiKey =   "AIzaSyDPr_DCptP8sV7JXOWidtIOFzfhqswgOSM";

showSnackBar(BuildContext context,
    {required String message, required Color backgroundColor, Color? textColor, Duration? duration, SnackBarBehavior? behavior, SnackBarAction? action}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: behavior,
      duration: duration ?? const Duration(milliseconds: 3000),
      content: Text(message, style: AppStyles.getRegularTextStyle(fontSize: 14, color: textColor ?? Colors.white)),
      backgroundColor: backgroundColor,
      dismissDirection: DismissDirection.startToEnd,
      action: action,
    ),
  );
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  final ByteData data = await rootBundle.load(path);
  final ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  final ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
}
