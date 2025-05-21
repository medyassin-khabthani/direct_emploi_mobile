import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../viewmodels/offre_view_model.dart';
import 'login_screen.dart';
import 'onboard_screen.dart';
import 'tabbar_screen.dart';
import '../services/user_manager.dart';
import 'worksearch_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isCheckingUserId = true;
  bool _isCheckingToken = true;

  @override
  void initState() {
    super.initState();
    _checkUserId();
    _checkToken();

    // Fetch total offers for the splash text (or any initial data).
    final offreViewModel = Provider.of<OffreViewModel>(context, listen: false);
    offreViewModel.fetchOffers(
      0, // For userId if unknown, pass 0 or any default
      {}, // queryParams
      0, // offset
      1, // limit (just need the total)
    );
  }

  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      UserManager.instance.setUserIdViaToken();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TabBarScreen(),
        ),
      );
    } else {
      setState(() {
        _isCheckingToken = false;
      });
    }
  }

  Future<void> _checkUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId != null) {
      UserManager.instance.setUserId(userId);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TabBarScreen(),
        ),
      );
    } else {
      setState(() {
        _isCheckingUserId = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access your view model
    final offreViewModel = Provider.of<OffreViewModel>(context);

    // Decide if you want to show the loading overlay
    bool isStillLoading =
        _isCheckingUserId || _isCheckingToken || offreViewModel.isLoading;

    return Scaffold(
      body: Stack(
        children: [
          // 1) Your main splash UI in the background:
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Spacer(),
                  Image.asset(
                    'assets/images/white_logo.png',
                    width: 180,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20.0),
                  // 2) Full-screen white loading overlay, only shown if loading:
                  if (isStillLoading)
                    Container(
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if (!isStillLoading)
                    Column(children: [
                      const Text(
                        "Trouver votre emploi",
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.white,
                          fontFamily: 'regular',
                        ),
                      ),
                      // Use your dynamic total here:
                      Text(
                        "parmi nos ${NumberFormat("#,###", "fr_FR").format(offreViewModel.total)} offres",
                        style: const TextStyle(
                          fontSize: 22.0,
                          color: Colors.white,
                          fontFamily: 'semi-bold',
                        ),
                      ),
                    ]),

                  const Spacer(),
                  // Buttons only if everything is done loading:
                  if (!isStillLoading)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 15.0,
                              ),
                            ),
                            child: const Text(
                              "Me connecter",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontFamily: "regular",
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              checkFirstSeen();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 15.0,
                              ),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: const Text(
                              "Commencer",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                                fontFamily: "regular",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => WorkSearchScreen()),
      );
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OnBoardScreen(isSignup: false),
        ),
      );
    }
  }
}
