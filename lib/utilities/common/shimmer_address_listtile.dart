import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerAddressTile extends StatelessWidget {
  const ShimmerAddressTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          title: Container(
            height: 16,
            margin: const EdgeInsets.only(bottom: 6),
            color: Colors.white,
          ),
          subtitle: Container(
            height: 14,
            color: Colors.white,
          ),
          trailing: Container(
            width: 24,
            height: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
