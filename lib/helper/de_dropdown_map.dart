import 'package:direct_emploi/helper/style.dart';
import 'package:flutter/material.dart';

class DEDropdownMap extends StatefulWidget {
  final String labelText;
  final Map<int, String> items;
  final int? initialKey; // Added initialKey parameter
  final int? forcedSelectedKey;
  final Function(int?) onChanged; // Changed to Function for flexibility

  const DEDropdownMap({
    Key? key,
    required this.labelText,
    required this.items,
    this.initialKey,
    required this.onChanged,
    this.forcedSelectedKey,
  }) : super(key: key);

  @override
  _DEDropdownMapState createState() => _DEDropdownMapState();
}

class _DEDropdownMapState extends State<DEDropdownMap> {
  int? _selectedKey;

  @override
  void initState() {
    super.initState();
    _selectedKey = widget.initialKey ?? widget.items.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: widget.forcedSelectedKey ?? _selectedKey,
      items: widget.items.entries.map<DropdownMenuItem<int>>((entry) {
        return DropdownMenuItem<int>(
          value: entry.key,
          child: Text(
            entry.value,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'regular', // Adjust according to your font
            ),
          ),
        );
      }).toList(),
      onChanged: (int? key) {
        setState(() {
          _selectedKey = key;
        });
        widget.onChanged(key); // Call the provided onChanged function
      },
      selectedItemBuilder: (BuildContext context) {
        return widget.items.entries.map<Widget>((entry) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.75, // Adjust the width as needed
            child: Text(
              entry.value,
              overflow: TextOverflow.ellipsis, // Handle long text with ellipsis
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'regular', // Adjust according to your font
              ),
            ),
          );
        }).toList();
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        filled: true,
        fillColor: inputBackground, // Default background color
        prefixIconColor: paragraphColor, // Default prefix icon color
        labelText: widget.labelText,
        labelStyle: const TextStyle(
          overflow: TextOverflow.ellipsis, // Handle long text in label
          fontSize: 12,
          fontFamily: 'regular', // Adjust according to your font
        ),
      ),
    );
  }
}
