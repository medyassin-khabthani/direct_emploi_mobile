
import 'package:flutter/material.dart';

const appColor = Color(0xFF44A2C6);
const appColorOpacity = Color(0x2644A2C6);
const textColor = Color(0xCC000000);
const paragraphColor = Color(0xFF95969D);
const strokeColor = Color(0x66000000);
const tenPercentBlack = Color(0x1A000000);
const inputBackground = Color(0xFFF9F9F9);
const placeholderColor=Color(0x66000000);


headText() {
  return const TextStyle(fontSize: 18, fontFamily: 'semi-bold');
}

appButton() {
  return ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: appColor,
    minimumSize: const Size.fromHeight(50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  );
}