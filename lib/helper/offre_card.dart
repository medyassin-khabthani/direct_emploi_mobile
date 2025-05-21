// import 'package:direct_emploi/helper/style.dart';
// import 'package:direct_emploi/helper/tags.dart';
// import 'package:flutter/material.dart';
//
// import '../utils/string_formatting.dart';
// import 'circular_icon_button.dart';
//
// class OffreCard extends StatelessWidget {
//   final String companyLogoPath; // Replace with your logo image path
//   final String jobTitle;
//   final String reference;
//   final String date;
//   final String jobDescription;
//   final List<String> tags;
//   final VoidCallback onPressed; // Action to perform on button press
//
//   const OffreCard({
//     Key? key,
//     required this.companyLogoPath,
//     required this.jobTitle,
//     required this.reference,
//     required this.date,
//     required this.jobDescription,
//     required this.tags,
//     required this.onPressed,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8.0),
//         side: const BorderSide(color: strokeColor, width: 0.5),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Image.network(companyLogoPath, height: 60.0,alignment: Alignment.centerLeft,),
//                 CircularIconButton(
//                   backgroundColor: Colors.white,
//                   iconSize: 18,
//                   size: 20,
//                   onPressed: () => {},
//                   iconPath: Icons.favorite,
//                   iconColor: appColorOpacity,
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 8.0),
//             Text(
//               "Ref: ${reference}",
//               style: const TextStyle(fontSize: 12.0, color: Colors.grey),
//             ),
//             const SizedBox(height: 8.0),
//             Text(
//               jobTitle,
//               style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 4.0),
//             Text(
//               date,
//               style: const TextStyle(fontSize: 12.0, color: Colors.grey),
//             ),
//             const SizedBox(height: 8.0),
//             // Html(
//             //   style: {
//             //     "body": Style(
//             //       fontSize: FontSize.medium,
//             //       padding: HtmlPaddings.zero,
//             //       margin: Margins.zero
//             //     ),
//             //   },
//             //   data:
//             //   jobDescription,
//             // ),
//             Text(
//               parseHtmlString(jobDescription)!,
//               style: const TextStyle(fontSize: 12.0),
//             ),
//             const SizedBox(height: 8.0),
//             Wrap(
//               spacing: 8.0,
//
//               children: tags.map((tag) => Tags(tag: tag,)).toList(),
//             ),
//             const SizedBox(height: 8.0),
//             OutlinedButton(
//               onPressed: onPressed,
//               child: const Text('Voir l\'offre',style: TextStyle(color: appColor),),
//               style: OutlinedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//                 side: const BorderSide(color: appColor),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// /*
//   Widget _buildTag(String tag) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 5.0),
//       padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0),
//       decoration: BoxDecoration(
//         color: appColorOpacity,
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Text(tag, style: const TextStyle(fontSize:12.0,color: textColor)),
//     );
//   }*/
// }
import 'package:direct_emploi/helper/style.dart';
import 'package:direct_emploi/helper/tags.dart';
import 'package:flutter/material.dart';

import '../utils/string_formatting.dart';
import 'circular_icon_button.dart';

class OffreCard extends StatelessWidget {
  final String companyLogoPath;
  final String jobTitle;
  final String reference;
  final String date;
  final String jobDescription;
  final List<String> tags;
  final VoidCallback onPressed;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const OffreCard({
    Key? key,
    required this.companyLogoPath,
    required this.jobTitle,
    required this.reference,
    required this.date,
    required this.jobDescription,
    required this.tags,
    required this.onPressed,
    required this.isFavorite,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(color: strokeColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(companyLogoPath, width:100 , alignment: Alignment.centerLeft),
                CircularIconButton(
                  backgroundColor: Colors.white,
                  iconSize: 18,
                  size: 20,
                  onPressed: onFavoriteToggle,
                  iconPath: Icons.favorite,
                  iconColor: isFavorite ? appColor : appColorOpacity,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              "Ref: $reference",
              style: const TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
            const SizedBox(height: 8.0),
            Text(
              jobTitle,
              style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            Text(
              date,
              style: const TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
            const SizedBox(height: 8.0),
            Text(
              parseHtmlString(jobDescription)!,
              style: const TextStyle(fontSize: 12.0),
            ),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              children: tags.map((tag) => Tags(tag: tag)).toList(),
            ),
            const SizedBox(height: 8.0),
            OutlinedButton(
              onPressed: onPressed,
              child: const Text('Voir l\'offre', style: TextStyle(color: appColor)),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                side: const BorderSide(color: appColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
