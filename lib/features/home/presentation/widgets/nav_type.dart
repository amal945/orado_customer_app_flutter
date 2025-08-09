import 'dart:io' show Platform;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

enum NavigationType {
  gesture,    // Full-screen gestures
  button,     // On-screen buttons
  physical,   // Physical buttons
  unknown
}

bool get isAndroid => Platform.isAndroid;
bool get isIOS => Platform.isIOS;

NavigationType getNavigationType(BuildContext context) {
  if (isIOS) {
    return NavigationType.gesture; // iOS always uses gestures
  }

  final padding = MediaQuery.of(context).padding;

  // Android detection
  if (padding.bottom <= 16) {
    return NavigationType.gesture;
  }

  if (padding.bottom > 16) {
    return NavigationType.button;
  }

  return NavigationType.physical;
}