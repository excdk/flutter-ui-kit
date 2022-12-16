import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final Color idleColor;
  final Color? activatedColor;
  final Color? disabledColor;
  final Color? disabledTextColor;
  final Color? activatedIconColor;
  final double? width;
  final double? height;
  final TextStyle textStyle;
  final Function() onTap;
  final bool isDisabled;
  const CustomButton({
    Key? key,
    required this.text,
    required this.onTap,
    required this.textStyle,
    required this.idleColor,
    this.width,
    this.height,
    this.activatedIconColor,
    this.activatedColor,
    this.disabledColor,
    this.disabledTextColor,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isDisabled) {
      return _buildWrapper(
        color: widget.disabledColor ?? widget.idleColor,
        child: Text(
          widget.text,
          style: widget.textStyle.copyWith(
              color: widget.disabledTextColor ?? widget.textStyle.color),
        ),
      );
    }
    if (!isLoading) {
      return GestureDetector(
        onTap: () async {
          if (widget.activatedIconColor != null ||
              widget.activatedColor != null) {
            setState(() {
              isLoading = true;
            });
            await widget.onTap();
            setState(() {
              isLoading = false;
            });
          } else {
            await widget.onTap();
          }
        },
        child: _buildWrapper(
          color: widget.idleColor,
          child: Text(
            widget.text,
            style: widget.textStyle,
          ),
        ),
      );
    } else {
      return _buildWrapper(
        color: widget.activatedColor ?? widget.idleColor,
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
              color: widget.activatedIconColor ?? widget.textStyle.color),
        ),
      );
    }
  }

  Widget _buildWrapper({required child, required color}) => Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Center(child: child));
}
