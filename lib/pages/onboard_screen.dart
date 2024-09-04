import 'package:direct_emploi/models/onboarding_content_model.dart';
import 'package:direct_emploi/pages/splash_screen.dart';
import 'package:direct_emploi/pages/tabbar_screen.dart';
import 'package:direct_emploi/pages/worksearch_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:direct_emploi/helper/style.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../services/user_manager.dart';

class OnBoardScreen extends StatefulWidget {
  final bool isSignup;
  const OnBoardScreen({Key? key, required this.isSignup}) : super(key: key);

  static const String pageId = "OnBoardScreen";

  @override
  State<OnBoardScreen> createState() => _FirstOnBoardScreenState();
}

class _FirstOnBoardScreenState extends State<OnBoardScreen> {
  int currentIndex =0;

  late PageController _controller;

  @override
  void initState(){
    _controller = PageController(initialPage: 0);
    super.initState();
  }
  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppbar(),
      body: SafeArea(child: _buildBody()),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,

    );
  }

  Widget _buildBody() {

    return Column(
      children: [
        Image.asset("assets/images/logo.png"),
        SizedBox(height: 20),
        Expanded(
          child: PageView.builder(
            itemCount: contents.length,
            controller: _controller,
            onPageChanged: (int index){
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder:(_,i) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(25.0,0,25.0,25.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      SvgPicture.asset(contents[i].image,
                      height: 250,),
                       Text(
                        contents[i].title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontFamily: "semi-bold",
                          color: textColor,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        contents[i].description,
                        style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: "regular",
                            color: paragraphColor,
                            height: 1.5),
                        textAlign: TextAlign.center,
                      ),

                    ],
                  ),
                ),
              );
            },
          ),
        ),

        Container(
          child: DotsIndicator(
            dotsCount: contents.length,
            position: currentIndex,
            decorator: DotsDecorator(
              size: const Size.square(8.0),
              activeSize: const Size(28.0, 8.0),
              activeColor: appColor,
              color: Color(0xFFE4E5E7),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
        ),
        SizedBox(height: 30,),
        Container(
          child: Padding(
            padding:  EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment:currentIndex == contents.length -1 ? MainAxisAlignment.center :MainAxisAlignment.spaceBetween ,
              children: [
                currentIndex == contents.length -1 ?
                     SizedBox():
                TextButton(
                   onPressed: () {
                     if(widget.isSignup == false){
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (_) => WorkSearchScreen(),
                         ),
                       );
                     }else{
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (_) => TabBarScreen(),
                         ),
                       );
                     }
                   },
                   child: Text(
                    currentIndex == contents.length -1 ? "":"Ignorer",

                    style: TextStyle(
                        fontSize: currentIndex == contents.length -1 ? 0 : 14,
                        fontFamily: "medium",
                        color: paragraphColor),
                                   ),
                 ),
                ElevatedButton(
                  onPressed: () {
                    if(currentIndex == contents.length - 1){
                      if(widget.isSignup == false){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WorkSearchScreen(),
                          ),
                        );
                      }else{
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TabBarScreen(),
                          ),
                        );
                      }

                    }
                    _controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
                  },

                  style: ElevatedButton.styleFrom(

                    backgroundColor: appColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: currentIndex == contents.length -1 ? 120.0: 40.0, vertical: 5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10.0), // Adjust as needed
                    ),
                  ),
                  child:  Text(
                    currentIndex == contents.length -1 ? "Explorer":"Suivant",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontFamily: "regular"),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
