import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIconCircleButton extends StatelessWidget {
  const SvgIconCircleButton(
    this.svgIconPath, {
    required this.backgroundColor,
    required this.iconColor,
    this.size = 48,
    this.padding = const EdgeInsets.all(8),
    this.onTap,
    super.key,
  });
  final void Function()? onTap;
  final String svgIconPath;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        padding: padding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          svgIconPath,
          color: iconColor,
        ),
      ),
    );
  }
}
