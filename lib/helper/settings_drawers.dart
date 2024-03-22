import 'package:accordion/accordion.dart';
import 'package:direct_emploi/helper/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class LeftDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 25.0),
          child: Text("Menu",style: TextStyle(fontSize: 20,fontFamily: "semi-bold")),
        ),
          ListTile(
            title: Text("Actualités",style: TextStyle(fontSize: 15,fontFamily: "medium"),),
            onTap: () {
              // Handle tap on menu item
            },
          ),

            Accordion(

              headerBackgroundColor: Colors.transparent,
              contentBorderColor: Colors.transparent,
              contentBorderWidth: 0,
              contentHorizontalPadding: 0,
              headerPadding: EdgeInsets.fromLTRB(8,13,8,5),
              scaleWhenAnimating: false,
              openAndCloseAnimation: true,
              paddingListBottom: 0,
              paddingListTop: 0,

              children: [
              AccordionSection(
              rightIcon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black54,
                size: 20,),
              isOpen: false,
              contentVerticalPadding: 0,
              contentBackgroundColor: drawerBackground,
              header: const Text('Conseils', style: TextStyle(fontSize: 15,fontFamily: "medium",)),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text("CV",style: TextStyle(fontSize: 14,fontFamily: "medium",color: paragraphColor),),
                    onTap: () {
                      print("tapped");
                    },
                  ),
                  ListTile(
                    title: Text("Lettre de motivation",style: TextStyle(fontSize: 14,fontFamily: "medium",color: paragraphColor),),
                    onTap: () {
                      // Handle tap on menu item
                    },
                  ),
                  ListTile(
                    title: Text("Entretien d'embauche",style: TextStyle(fontSize: 14,fontFamily: "medium",color: paragraphColor),),
                    onTap: () {
                      // Handle tap on menu item
                    },
                  ),
                ],
              ),
            ),],),
          ListTile(
            title: Text("Fiches Métiers de A à Z",style: TextStyle(fontSize: 15,fontFamily: "medium"),),
            onTap: () {
              // Handle tap on menu item
            },
          ),
          ListTile(
            title: Text("Les entreprises en ligne",style: TextStyle(fontSize: 15,fontFamily: "medium"),),
            onTap: () {
              // Handle tap on menu item
            },
          ),
          ListTile(
            title: Text("Qui sommes-nous ?",style: TextStyle(fontSize: 15,fontFamily: "medium"),),
            onTap: () {
              // Handle tap on menu item
            },
          ),
          ListTile(
            title: Text("Informations légales",style: TextStyle(fontSize: 15,fontFamily: "medium"),),
            onTap: () {
              // Handle tap on menu item
            },
          ),
          ListTile(
            title: Text("Politique de confidentialité",style: TextStyle(fontSize: 15,fontFamily: "medium"),),
            onTap: () {
              // Handle tap on menu item
            },
          ),
          ListTile(
            title: Text("Charte Cookies",style: TextStyle(fontSize: 15,fontFamily: "medium"),),
            onTap: () {
              // Handle tap on menu item
            },
          ),
          ListTile(
            title: Text("FAQ (questions fréquentes)",style: TextStyle(fontSize: 15,fontFamily: "medium"),),
            onTap: () {
              // Handle tap on menu item
            },
          ),
          ListTile(
            title: Text("Contact",style: TextStyle(fontSize: 15,fontFamily: "medium"),),
            onTap: () {
              // Handle tap on menu item
            },
          ),
        ],
      ),
    );
  }
}
class RightDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 25.0),
            child: Text("Paramétres",style: TextStyle(fontSize: 20,fontFamily: "semi-bold")),
          ),
          ListTile(
            leading: Icon(Icons.notifications,color: textColor,),
            title: Text("Gestion des notifications",style: TextStyle(fontSize: 15,fontFamily: "medium",color: textColor),),
            onTap: () {
              // Handle tap on menu item
            },
          ),
          ListTile(
            leading: Icon(Icons.mail,color: textColor,),
            title: Text("Gestion des emails",style: TextStyle(fontSize: 15,fontFamily: "medium",color: textColor),),
            onTap: () {
              // Handle tap on menu item
            },
          ),
          ListTile(
            leading: Icon(Icons.person,color: textColor,),
            title: Text("Modification de profil",style: TextStyle(fontSize: 15,fontFamily: "medium",color: textColor),),
            onTap: () {
              // Handle tap on menu item
            },
          ),
          ListTile(
            leading: Icon(Icons.lock,color: textColor,),
            title: Text("Création mot de passe",style: TextStyle(fontSize: 15,fontFamily: "medium",color: textColor),),
            onTap: () {
              // Handle tap on menu item
            },
          ),
          ListTile(
            leading: Icon(Icons.logout,color: textColor,),
            title: Text("Me déconnecter",style: TextStyle(fontSize: 15,fontFamily: "medium",color: textColor),),
            onTap: () {
              // Handle tap on menu item
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_forever,color: Colors.red,),
            title: Text("Supprimer mon compte",style: TextStyle(fontSize: 15,fontFamily: "medium",color: Colors.red),),
            onTap: () {
              // Handle tap on menu item
            },
          ),
        ],
      ),
    );
  }
}