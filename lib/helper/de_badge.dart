import 'package:flutter/material.dart';

class DEBadge extends StatelessWidget {
  final String value;
  final Color color;
  final double top;
  final double right;

  const DEBadge({
    Key? key,
    required this.value,
    this.color = Colors.red,
    this.top = 0,
    this.right = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
