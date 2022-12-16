import 'dart:math';

import 'package:flutter/material.dart';

class StoppableBottomSheet extends StatefulWidget {
  const StoppableBottomSheet({
    super.key,
    required this.animationController,
    required this.builder,
    required this.maxHeight,
    this.duration = const Duration(milliseconds: 300),
    this.decoration,
    this.enableDrag = true,
    this.minVelocityToFling = 700,
    this.stopPoints,
    this.canCloseByFlick = false,
    this.onClose,
  }) : assert(stopPoints == null || stopPoints.length >= 2);

  final AnimationController animationController;
  final Widget Function(BuildContext context) builder;
  final void Function()? onClose;
  final Duration duration;
  final bool enableDrag;
  final double minVelocityToFling;
  final bool canCloseByFlick;
  final List<double>? stopPoints;
  final double maxHeight;
  final BoxDecoration? decoration;

  @override
  _StoppableBottomSheetState createState() => _StoppableBottomSheetState();

  double findLowestStopPoint() {
    return stopPoints!.reduce(min);
  }

  double findHighestStopPoint() {
    return stopPoints!.reduce(max);
  }

  double findClosestStopPoint(double current) {
    return stopPoints!.reduce((a, b) {
      if ((current - a).abs() < (current - b).abs()) {
        return a;
      } else {
        return b;
      }
    });
  }
}

class _StoppableBottomSheetState extends State<StoppableBottomSheet> {
  Animation<double>? _animation;
  double? _parentHeight;
  double? _lowerBound;
  Curve? _currentCurve;
  Tween<double>? _tween;
  bool wasOpened = false;

  void _handleDragStart(DragStartDetails details) {
    _currentCurve = Curves.linear;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    double animationDelta = details.primaryDelta! / _parentHeight!;
    if (_lowerBound != null) {
      widget.animationController.value = max(
          widget.animationController.value - animationDelta,
          _lowerBound! / _parentHeight!);
    } else {
      widget.animationController.value -= animationDelta;
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    var velocity = details.primaryVelocity!;
    if (widget.stopPoints == null) {
      if (-velocity > widget.minVelocityToFling) {
        widget.animationController
            .fling(velocity: -details.primaryVelocity! / _parentHeight!);
      } else if (velocity > widget.minVelocityToFling) {
        widget.animationController
            .fling(velocity: -details.primaryVelocity! / _parentHeight!);
      }
    } else {
      if (-velocity > widget.minVelocityToFling) {
        widget.animationController
            .animateTo(widget.findHighestStopPoint() / _parentHeight!);
      } else if (velocity > widget.minVelocityToFling) {
        if (widget.canCloseByFlick) {
          widget.animationController
              .fling(velocity: -details.primaryVelocity! / _parentHeight!);
        } else {
          widget.animationController
              .animateTo(widget.findLowestStopPoint() / _parentHeight!);
        }
      } else {
        var closestStopPoint = widget.findClosestStopPoint(
            widget.animationController.value * _parentHeight!);
        widget.animationController.animateTo(closestStopPoint / _parentHeight!);
      }
    }
  }

  @override
  void initState() {
    wasOpened = false;
    _parentHeight = widget.maxHeight;
    _tween = Tween<double>(begin: 0, end: _parentHeight);
    widget.animationController.addListener(closeDetector);
    if (!widget.canCloseByFlick &&
        widget.stopPoints != null &&
        widget.stopPoints!.isNotEmpty) {
      _lowerBound = widget.findLowestStopPoint();
    }
    super.initState();
  }

  void closeDetector() {
    if (widget.animationController.value == 0 && wasOpened) {
      widget.onClose?.call();
    } else if (!wasOpened && widget.animationController.value > 0) {
      wasOpened = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.animationController,
        builder: (context, child) {
          return Container(
            decoration: widget.decoration,
            height: _tween!.transform((widget.animationController.value)),
            child: widget.enableDrag
                ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onVerticalDragStart: _handleDragStart,
                    onVerticalDragUpdate: _handleDragUpdate,
                    onVerticalDragEnd: _handleDragEnd,
                    child: widget.builder(context))
                : widget.builder(context),
          );
        });
  }
}
