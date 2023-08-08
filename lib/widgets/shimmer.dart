import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
  }) : shapeBorder = const RoundedRectangleBorder();

  const ShimmerWidget.circular({
    super.key,
    required this.height,
    required this.width,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Colors.black,
        // baseColor: Colors.grey[400]!,
        highlightColor: Colors.grey[300]!,
        period: const Duration(seconds: 2),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: Colors.grey[400]!,
              border: Border.all(),
              borderRadius: const BorderRadius.all(Radius.circular(36))),
          // ShapeDecoration(shape: shapeBorder, color: Colors.grey[400]!),
        ),
      );
}
