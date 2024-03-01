import 'package:direct_emploi/pages/tabbar_screen.dart';
import 'package:direct_emploi/pages/splash_screen.dart';
import 'package:flutter/material.dart';

import 'helper/style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Direct Emploi',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(

          primaryColor: appColor,
          colorScheme: ColorScheme.fromSeed(seedColor: appColor),
          fontFamily: 'regular',
          useMaterial3: true,
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor:appColor, //
              // Set the caret color for all TextFields
            ),

          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
                borderSide: BorderSide(color:strokeColor)
            ),
            // Define FloatingLabelStyle for color change on focus
            floatingLabelStyle: TextStyle(

              color: appColor,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: appColor), // Change this color
            ),
          ),
      ),
      home: SplashScreen()
    );
  }
}
