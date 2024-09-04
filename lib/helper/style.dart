
import 'package:flutter/material.dart';

const appColor = Color(0xFF44A2C6);
const appColorOpacity = Color(0x2644A2C6);
const backgroundColor = Color(0xFFf9fcfd);
const textColor = Color(0xCC000000);
const paragraphColor = Color(0xFF95969D);
const strokeColor = Color(0x22000000);
const tenPercentBlack = Color(0x1A000000);
const inputBackground = Color(0xFFF9F9F9);
const placeholderColor=Color(0x66000000);
const drawerBackground=Color(0xFFF0F4F7);
const headerBackground=Color(0xFFF2F2F2);
const yellowDot=Color(0xFFF6CA03);


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
outlinedAppButton(){
  return OutlinedButton.styleFrom(
    foregroundColor: appColor,
    side: const BorderSide(width: 1, color: appColor),
    minimumSize: const Size.fromHeight(50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  );
}