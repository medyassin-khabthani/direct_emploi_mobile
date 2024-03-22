import 'package:direct_emploi/helper/style.dart';
import 'package:flutter/cupertino.dart';

class Tags extends StatelessWidget {
  final String tag; // Replace with your logo image path

  const Tags({
    Key? key,
    required this.tag,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0),
      decoration: BoxDecoration(
        color: appColorOpacity,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(tag, style: const TextStyle(fontSize:12.0,color: textColor)),
    );
  }
}
