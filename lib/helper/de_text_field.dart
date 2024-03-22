import 'package:direct_emploi/helper/style.dart';
import 'package:flutter/material.dart';

class DETextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData? prefixIcon;
  final IconButton? suffixIcon;
  final String labelText;
  final bool obscureText; // Added obscureText parameter

  const DETextField({
    Key? key,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    required this.labelText,
    this.obscureText = false, // Default to false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText, // Added obscureText property
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null ? suffixIcon : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: tenPercentBlack,)
        ),
        filled: true,
        fillColor: inputBackground, // Default background color
        prefixIconColor: paragraphColor, // Default prefix icon color
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 12,
          fontFamily: 'regular', // Adjust according to your font
        ),
      ),
      style: const TextStyle(
        fontSize: 12,
        fontFamily: 'regular', // Adjust according to your font
      ),
    );
  }
}
