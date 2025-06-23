import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

import '../utilities.dart';

class CustomDialogue {
  Future<dynamic> showCustomLoadingDialogue(BuildContext context, {required String message}) {
    return showDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        builder: (c) => AlertDialog(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.white,
              shadowColor: Colors.transparent,
              content: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SpinKitCircle(color: AppColors.baseColor),
                    const SizedBox(height: 20),
                    Text(
                      message,
                      style: AppStyles.getMediumTextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ));
  }

  void showCustomDialogue({required BuildContext context, required List<Widget> content}) => showAdaptiveDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(157),
      builder: (BuildContext c) {
        return Dialog(
          alignment: Alignment.bottomCenter,
          insetPadding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: content),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Transform.translate(
                        offset: Offset(0, -70),
                        child: GestureDetector(
                          onTap: () => context.pop(),
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      });
}
