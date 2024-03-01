import 'package:direct_emploi/helper/style.dart';
import 'package:flutter/material.dart';

class FullWidthElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const FullWidthElevatedButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Take full width
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text,style: TextStyle(color: Colors.white),),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0), // Adjust as needed
          ),
          primary: appColor, // Set background color to blue
          minimumSize: const Size(double.infinity, 50), // Set minimum height
        ),
      ),
    );
  }
}
