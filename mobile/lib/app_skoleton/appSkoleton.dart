import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class AppSkoleton extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final BorderRadiusGeometry radius;

  const AppSkoleton(
      {Key? key,
      required this.width,
      required this.height,
      required this.radius,
      required this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
        borderRadius: radius,
        child: Container(
          margin: margin,
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: radius,
          ),
        ));
  }
}
