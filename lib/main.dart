import 'package:direct_emploi/pages/first_signup_screen.dart';
import 'package:direct_emploi/pages/login_screen.dart';
import 'package:direct_emploi/pages/offers_screen.dart';
import 'package:direct_emploi/pages/second_signup_screen.dart';
import 'package:direct_emploi/pages/signup_screen.dart';
import 'package:direct_emploi/pages/tabbar_screen.dart';
import 'package:direct_emploi/pages/splash_screen.dart';
import 'package:direct_emploi/pages/test_file.dart';
import 'package:direct_emploi/pages/third_signup_screen.dart';
import 'package:direct_emploi/services/user_manager.dart';
import 'package:direct_emploi/viewmodels/alerts_view_model.dart';
import 'package:direct_emploi/viewmodels/data_fetching_view_model.dart';
import 'package:direct_emploi/viewmodels/favorite_view_model.dart';
import 'package:direct_emploi/viewmodels/offre_details_view_model.dart';
import 'package:direct_emploi/viewmodels/offre_view_model.dart';
import 'package:direct_emploi/viewmodels/profile_view_model.dart';
import 'package:direct_emploi/viewmodels/saved_search_view_model.dart';
import 'package:direct_emploi/viewmodels/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'helper/style.dart';

void main() {

  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => OffreViewModel()),
            ChangeNotifierProvider(create: (_) => SavedSearchesViewModel()),
            ChangeNotifierProvider(create: (_) => OffreDetailsViewModel()),
            ChangeNotifierProvider(create: (_) => DataFetchingViewModel()),
            ChangeNotifierProvider(create: (_) => SignupViewModel()),
            ChangeNotifierProvider(create: (_) => FavoriteViewModel()),
            ChangeNotifierProvider(create: (_) => ProfileViewModel()),
            ChangeNotifierProvider(create: (_) => AlertsViewModel()),
            ChangeNotifierProvider(create: (_) => UserManager.instance),
          ],child:  MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        supportedLocales: const [
          Locale('fr', '')
        ],
        // Add localizationsDelegates here
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          // Important for Cupertino widgets
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode &&
                supportedLocale.countryCode == locale?.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
      title: 'Direct Emploi',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(

          primaryColor: appColor,
          colorScheme: ColorScheme.fromSeed(seedColor: appColor,surfaceTint:Colors.white70),
          fontFamily: 'regular',
          useMaterial3: true,
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor:appColor, //
              // Set the caret color for all TextFields
            ),

          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
                borderSide: BorderSide(color:tenPercentBlack)
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
      home: SplashScreen(),
        routes: {
          // ... other routes ...
          '/splash-screen': (
              context) => SplashScreen(),
          '/tabbar-screen': (
              context) => TabBarScreen(),
          '/offers-screen': (
              context) => OffersScreen(),
        }

    );
  }
}
