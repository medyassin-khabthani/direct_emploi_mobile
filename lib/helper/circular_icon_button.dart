import 'package:direct_emploi/helper/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'de_badge.dart';

class CircularIconButton extends StatelessWidget {
  final Function() onPressed;
  final IconData iconPath; // Path to your icon (SVG or other supported format)
  final double size; // Optional: Size of the button
  final Color backgroundColor; // Optional: Background color of the button
  final Color iconColor;
  final double iconSize;
  final String? badgeValue; // Optional: Value of the badge

  const CircularIconButton({
    required this.onPressed,
    required this.iconPath,
    required this.iconColor,
    required this.iconSize,
    this.size = 50.0,
    this.backgroundColor = Colors.white,
    this.badgeValue,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            side: BorderSide(width: 1, color: strokeColor),
            elevation: 0,
            shape: CircleBorder(),
            backgroundColor: backgroundColor,
            padding: EdgeInsets.all(size / 4), // Adjust padding as needed
          ),
          child: Icon(iconPath, color: iconColor, size: iconSize),
        ),
        if (badgeValue != null)
          DEBadge(
            value: badgeValue!,
            top: -6, // Adjust the position as needed
            right: 5, // Adjust the position as needed
          ),
      ],
    );
  }
}