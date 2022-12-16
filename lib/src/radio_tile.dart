import 'package:flutter/material.dart';

class RadioTile<T> extends StatelessWidget {
  final Function(T value) onSelected;
  final T value;
  final T? groupValue;
  final String label;
  final TextStyle? labelStyle;
  final Color activeColor;
  final Color idleColor;
  const RadioTile({
    super.key,
    required this.onSelected,
    required this.value,
    required this.groupValue,
    required this.label,
    required this.activeColor,
    required this.idleColor,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    bool isActive = value == groupValue;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onSelected(value),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: labelStyle),
            ),
            SizedBox(
              width: 24,
              height: 24,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 3,
                    color: isActive ? activeColor : idleColor,
                  ),
                ),
                child: isActive
                    ? Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: activeColor,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
