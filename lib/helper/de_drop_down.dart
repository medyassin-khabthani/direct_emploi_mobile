import 'package:direct_emploi/helper/style.dart';
import 'package:flutter/material.dart';

class DEDropdown extends StatefulWidget {
  final String labelText;
  final List<String> items;
  final String? initialValue; // Added initialValue parameter
  final Function(String?) onChanged; // Changed to Function for flexibility

  const DEDropdown({
    Key? key,
    required this.labelText,
    required this.items,
    this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<DEDropdown> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue ?? widget.items.first; // Set initial value
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedValue,
      items: widget.items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _selectedValue = value;
        });
        widget.onChanged(value); // Call the provided onChanged function
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        filled: true,
        fillColor: inputBackground, // Default background color
        prefixIconColor: paragraphColor, // Default prefix icon color
        labelText: widget.labelText,
        labelStyle: const TextStyle(
          fontSize: 12,
          fontFamily: 'regular', // Adjust according to your font
        ),
      ),
    );
  }
}
