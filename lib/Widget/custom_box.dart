import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Color color;
  final double? height;
  final double? width;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final Gradient? gradient;
  final Widget? child;
  final EdgeInsets? margin;
  final bool? topBorder;
  final bool? bottomBorder;
  final BoxShadow? boxShadow;

  CustomContainer({
    this.color = Colors.transparent,
    this.height,
    this.width,
    this.gradient,
    this.borderRadius = 0.0,
    this.borderWidth = 0.0,
    this.borderColor = Colors.transparent,
    this.child,
    this.margin,
    this.topBorder = false,
    this.bottomBorder = false,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      alignment: Alignment.center,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: (topBorder == false)
            ? BorderRadius.circular(borderRadius)
            : (bottomBorder == true)
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(borderRadius),
                    bottomRight: Radius.circular(borderRadius))
                : BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius)),
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        gradient: gradient,
        boxShadow: boxShadow != null ? [boxShadow!] : null,
      ),
      child: child,
    );
  }
}
