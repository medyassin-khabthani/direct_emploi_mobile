import 'dart:async';

import 'package:flutter/material.dart';

import 'onboard_screen.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    // After 3 seconds, navigate to the main screen
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, "Login");
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          padding: const EdgeInsets.all(25.0),
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Spacer(),
                      Image.asset(
                        'assets/images/white_logo.png', // Replace with your SVG logo asset path
                        width: 150,
                        color: Colors.white,
                      ),
                      SizedBox(height: 20.0),
                      const Text("Trouver votre emploi",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontFamily:'regular',
                      ),),
                      const Text("parmi nos 126 831 offres",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontFamily:'semi-bold',
                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              // Your button action here
                            },
                            child: Text(
                              "Me connecter",
                              style: TextStyle(color: Colors.white,fontSize: 10.0,fontFamily: "regular"),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                            ),
                          ),
                          SizedBox(width: 15.0,),
                          ElevatedButton(

                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const OnBoardScreen()));

                            },
                            style: ElevatedButton.styleFrom(
                              padding:EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0), backgroundColor: Colors.white ,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0), // Adjust as needed
                              ), // Background color
                            ),
                            child: const Text(
                              "Commencer",
                              style: TextStyle(color: Colors.black,fontSize: 10.0,fontFamily: "regular"),
                            ),

                          ),
                        ],
                      ),
                      Spacer()
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),

    );
  }
}
