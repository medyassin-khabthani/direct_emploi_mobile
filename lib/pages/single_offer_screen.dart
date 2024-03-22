import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/horizontal_scrollable_menu.dart';
import '../helper/style.dart';
import '../helper/tags.dart';
import 'package:share_plus/share_plus.dart';

class SingleOfferScreen extends StatefulWidget {
  const SingleOfferScreen({super.key});

  @override
  State<SingleOfferScreen> createState() => _SingleOfferScreenState();
}

class _SingleOfferScreenState extends State<SingleOfferScreen> {
  int selectedIndex = 0;
  final List<String> tags = [
  "Cdi",
  "Santé - Paramédical",
  "Ile-de-France - Paris"
  ];
  final List<String> titles = [
  "Description de l'offre",
  "Profil recherché",
  "Présentation de l'entreprise"
  ];
  final List<Widget> contents = [
  Text("Ceci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offreCeci est une grande description de l'offre",textAlign:TextAlign.left),
    Text("ceci est un Profil recherché trés grand",textAlign:TextAlign.left),
    Text("ici on peut faire la Présentation de l'entreprise",textAlign:TextAlign.left)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: headerBackground,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(){
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: true,
      title: Text(
        'IBODE Bloc Thoracique et Pulmonaire 10h F/H',
        style: TextStyle(fontSize: 14, color: textColor,fontFamily: 'semi-bold'),
      ),
      actions: [
        IconButton(onPressed: (){

        }, icon: Icon(Icons.favorite_outline)),
        IconButton(onPressed: (){
          Share.share('Regardez cette offre https://www.directemploi.com/candidatOffre/45322498');
        }, icon: Icon(Icons.share))
      ],
    );
  }

  Widget _buildBody(){
    return Container(
      height: double.infinity,
      child: Stack(
        children: [
          SingleChildScrollView(
          child: Column(

              children: [

                Container(
                    width: double.infinity,
                    decoration:BoxDecoration(
                        color:Colors.white
                    ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/company_logo2.jpg",height: 80.0,alignment: Alignment.center,
                        filterQuality: FilterQuality.high,),
                        Text("01 Février 2024 - FR-093335",style: TextStyle(fontSize: 12,color: paragraphColor),),
                        const SizedBox(height: 10.0,),
                        Text("IBODE Bloc Thoracique et Pulmonaire 10h F/H",
                          style: TextStyle(fontSize: 16,color: textColor,fontFamily: 'semi-bold')
                          ,textAlign:TextAlign.center),
                        const SizedBox(height: 10.0,),
                        Wrap(
                          spacing: 8.0,

                          children: tags.map((tag) => Tags(tag: tag,)).toList(),
                        ),
                        const SizedBox(height: 10.0,),
                        TextButton(onPressed: (){

                        }, child: Text("Découvrir l'entreprise, toutes les offres"))


                      ],
                    ),
                  ),
                ),
                HorizontalScrollableMenu(titles: this.titles,
                  contents:this.contents ,
                  onTitleClick: (index) =>setState(() {selectedIndex = index;}),

                ),
               Container(
                 margin: EdgeInsets.only(bottom: 100.0),
                   width: double.infinity,
                   child: Padding(

                     padding: const EdgeInsets.symmetric(horizontal: 15.0),
                     child: this.contents[selectedIndex],
                   )),

              ]
          ),
        ),
          Positioned(
            bottom: 20.0, // Adjust positioning as needed
            left: 0.0, // Start from left edge (full width)
            right: 0.0, // Extend to right edge (full width)
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Expanded(
                    child: FloatingActionButton(
                      elevation: 2,
                      backgroundColor: appColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Adjust corner radius
                      ),
                      onPressed: () {
                        // Your FAB action
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0), // Adjust padding
                        child: Text(
                          "Postuler maintenant", // Replace with your text
                          style: TextStyle(
                            color: Colors.white, // Adjust text color
                            fontSize: 16.0, // Adjust font size
                          ),
                        ),
                      ), // Adjust border
                    ),
                  ),
                ],
              ),
            ),
          ),],
      ),
    );
  }
}
