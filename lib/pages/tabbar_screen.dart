import 'package:direct_emploi/helper/style.dart';
import 'package:direct_emploi/pages/alerts_screen.dart';
import 'package:direct_emploi/pages/offers_screen.dart';
import 'package:direct_emploi/pages/profile_screen.dart';
import 'package:direct_emploi/pages/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    SearchScreen(),
    OffersScreen(),
    AlertsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(border: Border(top: BorderSide(width: 0.25,color: strokeColor))),
        child:  Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
          child: GNav(

            gap: 8,
            activeColor: appColor,
            color: strokeColor,
            tabBackgroundColor: appColorOpacity,
            selectedIndex: _selectedIndex,
            padding: EdgeInsets.all(16),
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const [
            GButton(icon: Icons.search_sharp,text: "Recherche",),
            GButton(icon: Icons.work,text: "Offres",),
            GButton(icon: Icons.notifications,text: "Alertes",),
            GButton(icon: Icons.person_rounded,text:"Profil")
          ],),
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex)
    );
  }
  Widget _buildBody() {
    return SizedBox();
  }
}
