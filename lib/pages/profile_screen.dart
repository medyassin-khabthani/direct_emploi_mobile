import 'package:direct_emploi/helper/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../helper/circular_icon_button.dart';
import '../helper/custom_shape.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
  
  Widget _buildBody(){
    return Scaffold(

      appBar:  AppBar(
        toolbarHeight: 350,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: Customshape(),
          child: Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
            color: appColorOpacity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 40),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircularIconButton(
                        onPressed: () {
                          print('Circular icon button pressed!');
                        },
                        iconPath: Icons.menu_rounded, iconColor: strokeColor, // Replace with your icon path
                      ),
                      CircularPercentIndicator(
                        radius: 70.0,
                        lineWidth: 12.0,
                        animation: true,
                        backgroundColor: tenPercentBlack,
                        percent: 0.35,
                        center: Text(
                          "35%",
                          style: TextStyle(fontFamily: "semi-bold",fontSize: 18),
                        ),
                        progressColor: appColor,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                      CircularIconButton(
                        onPressed: () {
                          print('Circular icon button pressed!');
                        },
                        iconPath: Icons.settings, iconColor: strokeColor, // Replace with your icon path
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  const Text("Mon profil",style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: "semi-bold"
                  ),),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularIconButton(
                        onPressed: () {
                          print('Circular icon button pressed!');
                        },
                        iconPath: CupertinoIcons.paperclip, iconColor: appColor, // Replace with your icon path
                      ),
                      CircularIconButton(
                        onPressed: () {
                            print('Circular icon button pressed!');
                        },
                        iconPath: CupertinoIcons.heart, iconColor: appColor, // Replace with your icon path
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFffffff),
    );
  }
}
