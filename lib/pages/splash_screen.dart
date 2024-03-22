import 'dart:async';

import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'onboard_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Spacer(),
                Image.asset(
                  'assets/images/white_logo.png', // Replace with your SVG logo asset path
                  width: 180,
                  color: Colors.white,
                ),
                SizedBox(height: 20.0),
                const Text(
                  "Trouver votre emploi",
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                    fontFamily: 'regular',
                  ),
                ),
                const Text(
                  "parmi nos 126 831 offres",
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                    fontFamily: 'semi-bold',
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Text(
                          "Me connecter",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontFamily: "regular"),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 15.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OnBoardScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 15.0),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20.0), // Adjust as needed
                          ), // Background color
                        ),
                        child: const Text(
                          "Commencer",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                              fontFamily: "regular"),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 60,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
