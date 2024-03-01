import 'package:direct_emploi/helper/style.dart';
import 'package:flutter/material.dart';

class SingleSelectChip extends StatefulWidget {
  final List<String> itemList;
  final Function(String)? onSelectionChanged;

  const SingleSelectChip(this.itemList, {super.key, this.onSelectionChanged});

  @override
  _SingleSelectChipState createState() => _SingleSelectChipState();
}

class _SingleSelectChipState extends State<SingleSelectChip> {
  String selectedItem = "";

  _buildChoiceList() {
    List<Widget> choices = [];

    widget.itemList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: ChoiceChip(
          selectedColor: appColor,

          side: BorderSide(

            color: selectedItem == item ? Colors.transparent : Colors.grey,
          ),
          label: Text(item,),
          labelStyle: TextStyle(
            color: selectedItem == item ? Colors.white : placeholderColor, // Change text color
          ),
          selected: selectedItem == item,
          checkmarkColor: Colors.white,
          onSelected: (selected) {
            setState(() {
              selectedItem = selected ? item : "";

              widget.onSelectionChanged?.call(selectedItem);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
