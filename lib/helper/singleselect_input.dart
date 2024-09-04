import 'package:flutter/material.dart';
import 'package:direct_emploi/helper/style.dart';

class SingleSelectChip extends StatefulWidget {
  final Map<String, String> options;
  final String? initialSelectedKey;
  final Function(String)? onSelectionChanged;

  const SingleSelectChip(this.options, {super.key, this.initialSelectedKey, this.onSelectionChanged});

  @override
  _SingleSelectChipState createState() => _SingleSelectChipState();
}

class _SingleSelectChipState extends State<SingleSelectChip> {
  late String selectedKey;

  @override
  void initState() {
    super.initState();
    selectedKey = widget.initialSelectedKey ?? "";
  }

  List<Widget> _buildChoiceList() {
    List<Widget> choices = [];

    widget.options.forEach((key, value) {
      choices.add(ChoiceChip(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        selectedColor: appColor,
        side: BorderSide(
          color: selectedKey == key ? Colors.transparent : Colors.grey,
        ),
        label: Text(value),
        labelStyle: TextStyle(
          color: selectedKey == key ? Colors.white : placeholderColor, // Change text color
        ),
        selected: selectedKey == key,
        checkmarkColor: Colors.white,
        onSelected: (selected) {
          setState(() {
            selectedKey = selected ? key : "";
            widget.onSelectionChanged?.call(selectedKey);
          });
        },
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 10,
      spacing: 20,
      children: _buildChoiceList(),
    );
  }
}
