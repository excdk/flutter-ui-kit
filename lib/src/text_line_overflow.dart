import 'package:flutter/material.dart';

class TextLineOverflow extends StatelessWidget {
  const TextLineOverflow({
    required this.text,
    required this.style,
    Key? key,
  }) : super(key: key);

  final String? text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Text(
        text ?? "Неизвестно",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      ),
    );
  }
}
