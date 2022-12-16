import 'package:flutter/material.dart';

class OutlineInputBorderLabelInside extends InputBorder {
  final BorderRadius borderRadius;

  const OutlineInputBorderLabelInside({
    super.borderSide = const BorderSide(),
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
  });

  @override
  OutlineInputBorderLabelInside copyWith(
      {BorderSide? borderSide, BorderRadius? borderRadius}) {
    return OutlineInputBorderLabelInside(
        borderSide: borderSide ?? this.borderSide,
        borderRadius: borderRadius ?? this.borderRadius);
  }

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(borderSide.width);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(borderRadius
          .resolve(textDirection)
          .toRRect(rect)
          .deflate(borderSide.width));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  bool get isOutline => false;

  @override
  void paint(Canvas canvas, Rect rect,
      {double? gapStart,
      double gapExtent = 0.0,
      double gapPercentage = 0.0,
      TextDirection? textDirection}) {
    final Paint paint = borderSide.toPaint();
    final RRect outer = borderRadius.toRRect(rect);
    final RRect center = outer.deflate(borderSide.width / 2.0);
    canvas.drawRRect(center, paint);
  }

  @override
  OutlineInputBorderLabelInside scale(double t) {
    return OutlineInputBorderLabelInside(
      borderSide: borderSide.scale(t),
      borderRadius: borderRadius * t,
    );
  }
}
