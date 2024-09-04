import 'package:direct_emploi/helper/style.dart';
import 'package:flutter/material.dart';

class DEBackButton extends StatelessWidget {
  const DEBackButton({super.key,});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context,true),
      child: Icon(Icons.arrow_back_rounded, color: appColor),
    );
  }
}
