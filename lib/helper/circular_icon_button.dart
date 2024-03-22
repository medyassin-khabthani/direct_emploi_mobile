import 'package:direct_emploi/helper/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CircularIconButton extends StatelessWidget {
  final Function() onPressed;
  final IconData iconPath; // Path to your icon (SVG or other supported format)
  final double size; // Optional: Size of the button
  final Color backgroundColor; // Optional: Background color of the button
  final Color iconColor;
  final double iconSize;

  const CircularIconButton({
    required this.onPressed,
    required this.iconPath,
    required this.iconColor,
    required this.iconSize,
    this.size = 50.0,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        side: BorderSide(width: 0.5,color: strokeColor),
        elevation: 0,
        shape: CircleBorder(),
        backgroundColor: backgroundColor,
        padding: EdgeInsets.all(size / 4), // Adjust padding as needed
      ),
      child: Icon(iconPath,color: iconColor,size: iconSize,)
    );
  }
}