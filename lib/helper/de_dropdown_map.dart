import 'package:flutter/material.dart';

import '../helper/style.dart';

class DEDropdownMap extends StatefulWidget {
  final String labelText;
  final Map<int, String> items;

  /// If you want to set an initial selection the first time
  final int? initialKey;

  /// If you want to override the selected key from above
  final int? forcedSelectedKey;

  /// Called when the user picks a new item
  final ValueChanged<int?> onChanged;

  const DEDropdownMap({
    Key? key,
    required this.labelText,
    required this.items,
    this.initialKey,
    this.forcedSelectedKey,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<DEDropdownMap> createState() => _DEDropdownMapState();
}

class _DEDropdownMapState extends State<DEDropdownMap> {
  int? _selectedKey;

  @override
  void initState() {
    super.initState();
    // Use initialKey if provided, else use the first item’s key, else null
    _selectedKey = widget.initialKey ?? widget.items.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      // If forcedSelectedKey is non-null, it overrides _selectedKey
      value: widget.forcedSelectedKey ?? _selectedKey,
      items: widget.items.entries.map<DropdownMenuItem<int>>((entry) {
        return DropdownMenuItem<int>(
          value: entry.key,
          child: Text(
            entry.value,
            style: const TextStyle(fontSize: 12, fontFamily: 'regular'),
          ),
        );
      }).toList(),
      onChanged: (int? newKey) {
        setState(() => _selectedKey = newKey);
        widget.onChanged(newKey);
      },
      selectedItemBuilder: (BuildContext context) {
        // This determines how the selected item is displayed
        return widget.items.entries.map<Widget>((entry) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Text(
              entry.value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontFamily: 'regular'),
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
        fillColor: inputBackground,
        labelText: widget.labelText,
        labelStyle: const TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: 12,
          fontFamily: 'regular',
        ),
      ),
    );
  }
}
