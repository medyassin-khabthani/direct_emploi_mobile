import 'package:direct_emploi/helper/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:accordion/accordion.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../helper/circular_icon_button.dart';
import '../helper/custom_shape.dart';
import '../helper/settings_drawers.dart';
import '../models/settings_menu_item_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,

      key: _scaffoldKey,
      appBar: _buildAppBar(),
      backgroundColor: const Color(0xFFffffff),
      body: _buildBody(),
      drawer: LeftDrawer(),
      endDrawer: RightDrawer(),
    );
  }
  PreferredSizeWidget _buildAppBar(){
    return AppBar(
      leading:new Container(),
      actions: <Widget>[
        new Container(),
      ],
      toolbarHeight: 320,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      flexibleSpace: ClipPath(
        clipper: Customshape(),
        child: Container(
          height: 400,
          width: MediaQuery.of(context).size.width,
          color: appColorOpacity,
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 15.0, vertical: 40),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircularIconButton(
                      onPressed: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      iconPath: Icons.menu_rounded,
                      iconColor: strokeColor,
                      iconSize: 24,

                    ),
                    CircularPercentIndicator(
                      radius: 70.0,
                      lineWidth: 12.0,
                      animation: true,
                      backgroundColor: tenPercentBlack,
                      percent: 0.35,
                      center: Text(
                        "35%",
                        style:
                        TextStyle(fontFamily: "semi-bold", fontSize: 18),
                      ),
                      progressColor: appColor,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                    CircularIconButton(
                      onPressed: () {
                        _scaffoldKey.currentState!.openEndDrawer();
                      },
                      iconPath: Icons.settings,
                      iconColor: strokeColor,
                      iconSize: 24,
// Replace with your icon path
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                const Text(
                  "Mon profil",
                  style: TextStyle(fontSize: 18.0, fontFamily: "semi-bold"),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularIconButton(
                      onPressed: () {
                        print('Circular icon button pressed!');
                      },
                      iconPath: CupertinoIcons.paperclip,
                      iconColor: appColor,
                      iconSize: 24,

                    ),
                    CircularIconButton(
                      onPressed: () {
                        print('Circular icon button pressed!');
                      },
                      iconPath: CupertinoIcons.heart,
                      iconColor: appColor,
                      iconSize: 24,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final menuItem = menuItems[index];
          return ListTile(
            title: Text(menuItem.title),
            trailing: Icon(Icons.chevron_right_rounded),
            onTap: () {
              // Handle tap on menu item
            },
          );
        },
      ),
    );
  }
}
