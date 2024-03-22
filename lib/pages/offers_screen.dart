import 'package:direct_emploi/helper/offre_card.dart';
import 'package:direct_emploi/pages/single_offer_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/style.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: _buildBody(),
      )) ,
    );
  }

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      backgroundColor: headerBackground,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,

      title: Text(
        "Offres d'emploi Infirmier",
        style: TextStyle(fontSize: 14, color: textColor,fontFamily: 'semi-bold'),
      ),
      actions: [
        // Existing actions if any
        IconButton(
          icon: Icon(Icons.search,color: appColor,), // You can choose any icon from the Icons class
          onPressed: () {
            // Define the functionality when the icon is pressed
            print('Search Icon Pressed');
          },
        ),
      ],
    );
  }
  Widget _buildBody(){
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: '164 ', style: TextStyle(fontSize: 16, fontFamily:"bold",color: textColor)),
                      TextSpan(text: 'offres trouvés', style: TextStyle(fontSize: 16,fontFamily:"medium",color: textColor)),
                    ],
                  ),
                ),              
                IconButton(icon: Icon(Icons.filter_list_outlined), onPressed: () { print("clicked"); },)
              ],
            ),
          ),
          OffreCard(
            companyLogoPath: "assets/images/company_logo.png",
            jobTitle: "IBODE Bloc Thoracique et Pulmonaire 10h F/H",
            date:
            "12 février 2024 - PARIS - Assistance Publique - Hôpitaux de Paris",
            jobDescription:
            "Gestion des risques liés à l'activité et à l'environnement opératoire· Elaboration et mise en oeuvre d'une démarche de soins individualisée en bloc opératoire et secteurs associés· Organisation et coordination des soins infirmiers en salle d'intervention· Traçabilit...",
            tags: [
              "Cdi",
              "Santé - Paramédical - Biologie - Pharmacie",
              "Ile-de-France - Paris"
            ],
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SingleOfferScreen()));
            },
          ),
          OffreCard(
            companyLogoPath: "assets/images/company_logo.png",
            jobTitle: "IBODE Bloc Thoracique et Pulmonaire 10h F/H",
            date:
            "12 février 2024 - PARIS - Assistance Publique - Hôpitaux de Paris",
            jobDescription:
            "Gestion des risques liés à l'activité et à l'environnement opératoire· Elaboration et mise en oeuvre d'une démarche de soins individualisée en bloc opératoire et secteurs associés· Organisation et coordination des soins infirmiers en salle d'intervention· Traçabilit...",
            tags: [
              "Cdi",
              "Santé - Paramédical - Biologie - Pharmacie",
              "Ile-de-France - Paris"
            ],
            onPressed: () {
              print("test");
            },
          ),
        ],
      ),
    );
  }
}


