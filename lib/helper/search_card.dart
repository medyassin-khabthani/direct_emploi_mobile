import 'package:direct_emploi/helper/style.dart';
import 'package:direct_emploi/helper/tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../datas/de_datas.dart';
import 'circular_icon_button.dart';

class SearchCard extends StatelessWidget {
  final String? query; // Replace with your logo image path
  final String? localisation;
  final String? contrat;
  final String date;

  final VoidCallback onTap; // Action to perform on button press
  final VoidCallback onDelete; // Action to perform on button press

  const SearchCard({
    Key? key,
    this.query,
    this.localisation,
    this.contrat,
    required this.date,
    required this.onTap, required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.white,
      focusColor: Colors.white,
      highlightColor: Colors.white,
      splashColor: Colors.white,
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.only(bottom: 20),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(color: strokeColor, width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date,
                    style: TextStyle(color: paragraphColor, fontSize: 12),
                  ),
                  IconButton(
                      onPressed: onDelete,
                      icon: Icon(
                        Icons.delete,
                        size: 20,
                        color: paragraphColor,
                      ))
                ],
              ),
              SizedBox(
                height: 0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Métier: ",style: TextStyle(fontFamily: "semi-bold", fontSize: 13)),
                    query != null && query!.isNotEmpty
                        ? Text(
                      "$query",
                      style: TextStyle(fontFamily: "medium", fontSize: 13),
                    )
                        : const Text("Tous les métiers",
                        style: TextStyle(fontFamily: "medium", fontSize: 13)),
                  ],),

                  SizedBox(height: 10,),
                  Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Localisation: ",style: TextStyle(fontFamily: "semi-bold", fontSize: 13)),
                    localisation != null && localisation!.isNotEmpty
                        ? Text("$localisation",
                        style: TextStyle(fontFamily: "medium", fontSize: 13))
                        : const Text("Partout",
                        style: TextStyle(fontFamily: "medium", fontSize: 13)),
                  ],),

                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Type de contrat: ",style: TextStyle(fontFamily: "semi-bold", fontSize: 13)),
                      contrat != null && contrat!.isNotEmpty
                          ? Text("${contratOptions[contrat]}",
                          style: TextStyle(fontFamily: "medium", fontSize: 13))
                          : const Text("Tous les contrats",
                          style: TextStyle(fontFamily: "medium", fontSize: 13)),
                    ],
                  )

                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     query != null && query!.isNotEmpty
              //         ? Text(
              //             "$query -",
              //             style: TextStyle(fontFamily: "medium", fontSize: 13),
              //           )
              //         : const Text("Tous les métiers -",
              //             style: TextStyle(fontFamily: "medium", fontSize: 13)),
              //     localisation != null && localisation!.isNotEmpty
              //         ? Text(" $localisation -",
              //             style: TextStyle(fontFamily: "medium", fontSize: 13))
              //         : const Text(" Partout -",
              //             style: TextStyle(fontFamily: "medium", fontSize: 13)),
              //     contrat != null && contrat!.isNotEmpty
              //         ? Text(" ${contratOptions[contrat]}",
              //             style: TextStyle(fontFamily: "medium", fontSize: 13))
              //         : const Text(" Tous les contrats",
              //             style: TextStyle(fontFamily: "medium", fontSize: 13)),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
