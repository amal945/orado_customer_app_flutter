import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OlaMapWidget extends StatelessWidget {
  const OlaMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AndroidView(
      viewType: 'ola_map_view',
      onPlatformViewCreated: (int id) {
        // Additional setup if needed
      },
      creationParams: null,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
