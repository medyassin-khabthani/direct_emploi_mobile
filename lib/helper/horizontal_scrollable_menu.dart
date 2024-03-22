import 'package:direct_emploi/helper/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HorizontalScrollableMenu extends StatefulWidget {
  final List<String> titles; // List of titles for the menu
  final List<Widget> contents; // List of widgets to display for each title (same length as titles)
  final Function(int) onTitleClick; // Callback function for title clicks

  const HorizontalScrollableMenu({
    Key? key,
    required this.titles,
    required this.contents,
    required this.onTitleClick,
  }) : super(key: key);

  @override
  State<HorizontalScrollableMenu> createState() => _HorizontalScrollableMenuState();
}
class _HorizontalScrollableMenuState extends State<HorizontalScrollableMenu> {
  int selectedIndex = 0; // Keeps track of the currently selected title

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.titles.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
                widget.onTitleClick(index); // Call the callback
              });
            },
            child: Container(

              padding: EdgeInsets.all(15.0),
              child: Text(widget.titles[index],style: TextStyle(color: selectedIndex == index ? textColor : paragraphColor,fontFamily:selectedIndex == index ? "bold" : "medium" ),),
            ),
          );
        },
      ),
    );
  }
}