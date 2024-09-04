import 'package:accordion/accordion.dart';
import 'package:direct_emploi/helper/style.dart';
import 'package:direct_emploi/helper/webpage_view.dart';
import 'package:direct_emploi/pages/change_password_screen.dart';
import 'package:direct_emploi/pages/create_password_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../services/user_manager.dart';
import '../viewmodels/profile_view_model.dart';

class LeftDrawer extends StatelessWidget {

  late final WebViewController actualitesWebViewController = WebViewController()
    ..loadRequest(Uri.parse('https://www.directemploi.com/article/list'));

  late final WebViewController cvWebViewController = WebViewController()
    ..loadRequest(Uri.parse('https://www.directemploi.com/conseil/cv'));

  late final WebViewController lmWebViewController = WebViewController()
    ..loadRequest(Uri.parse('https://www.directemploi.com/conseil/lettreMotivation'));

  late final WebViewController entretienWebViewController = WebViewController()
    ..loadRequest(Uri.parse('https://www.directemploi.com/conseil/entretienEmbauche'));

  late final WebViewController ficheMetierWebViewController = WebViewController()
    ..loadRequest(Uri.parse('https://www.directemploi.com/conseil/listeMetiers'));

  late final WebViewController entrepriseWebViewController = WebViewController()
    ..loadRequest(Uri.parse('https://www.directemploi.com/entreprises'));

  late final WebViewController nousWebViewController = WebViewController()
    ..loadRequest(Uri.parse('https://www.directemploi.com/page/direct-emploi-qui-sommes-nous'));

  late final WebViewController legaleWebViewController = WebViewController()
    ..loadRequest(Uri.parse('https://www.directemploi.com/page/mentions-legales'));

  late final WebViewController confidentialWebViewController = WebViewController()
    ..loadRequest(Uri.parse('https://www.directemploi.com/page/direct-emploi-politique-de-confidentialite-des-donnees'));

  late final WebViewController cookiesWebViewController = WebViewController()
    ..loadRequest(Uri.parse('https://www.directemploi.com/page/conditions-generales-d-utilisation-cookies'));

  late final WebViewController faqWebViewController = WebViewController()
    ..loadRequest(Uri.parse('https://www.directemploi.com/page/faq-direct-emploi-les-questions-frequentes'));

  late final WebViewController contactWebViewController = WebViewController()
    ..loadRequest(Uri.parse('https://www.directemploi.com/contact'));


  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 25.0),
            child: Text("Menu",
                style: TextStyle(fontSize: 20, fontFamily: "semi-bold")),
          ),
          ListTile(
            title: Text(
              "Actualités",
              style: TextStyle(fontSize: 15, fontFamily: "medium"),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebPageView(controller: actualitesWebViewController,webPageTitle: "Direct Emploi - Actualités",)));
            },
          ),
          Accordion(
            headerBackgroundColor: Colors.transparent,
            contentBorderColor: Colors.transparent,
            contentBorderWidth: 0,
            contentHorizontalPadding: 0,
            headerPadding: EdgeInsets.fromLTRB(8, 13, 8, 5),
            scaleWhenAnimating: false,
            openAndCloseAnimation: true,
            paddingListBottom: 0,
            paddingListTop: 0,
            children: [
              AccordionSection(
                rightIcon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black54,
                  size: 20,
                ),
                isOpen: false,
                contentVerticalPadding: 0,
                contentBackgroundColor: drawerBackground,
                header: const Text('Conseils',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "medium",
                    )),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        "CV",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "medium",
                            color: paragraphColor),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebPageView(controller: cvWebViewController,webPageTitle: "Direct Emploi - Conseils cv",)));
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Lettre de motivation",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "medium",
                            color: paragraphColor),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebPageView(controller: lmWebViewController,webPageTitle: "Direct Emploi - Conseils de lettre de motivation",)));
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Entretien d'embauche",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "medium",
                            color: paragraphColor),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebPageView(controller: entretienWebViewController,webPageTitle: "Direct Emploi - Conseils pour entretien ",)));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          ListTile(
            title: Text(
              "Fiches Métiers de A à Z",
              style: TextStyle(fontSize: 15, fontFamily: "medium"),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebPageView(controller: ficheMetierWebViewController,webPageTitle: "Direct Emploi - Fiches métiers de A à Z",)));
            },
          ),
          ListTile(
            title: Text(
              "Les entreprises en ligne",
              style: TextStyle(fontSize: 15, fontFamily: "medium"),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebPageView(controller: entretienWebViewController,webPageTitle: "Direct Emploi - Les entreprises en ligne",)));
            },
          ),
          ListTile(
            title: Text(
              "Qui sommes-nous ?",
              style: TextStyle(fontSize: 15, fontFamily: "medium"),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebPageView(controller: nousWebViewController,webPageTitle: "Direct Emploi - Qui sommes-nous ?",)));
            },
          ),
          ListTile(
            title: Text(
              "Informations légales",
              style: TextStyle(fontSize: 15, fontFamily: "medium"),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebPageView(controller: legaleWebViewController,webPageTitle: "Direct Emploi - Informations légales",)));
            },
          ),
          ListTile(
            title: Text(
              "Politique de confidentialité",
              style: TextStyle(fontSize: 15, fontFamily: "medium"),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebPageView(controller: confidentialWebViewController,webPageTitle: "Direct Emploi - Politique de confidentialité",)));            },
          ),
          ListTile(
            title: Text(
              "Charte Cookies",
              style: TextStyle(fontSize: 15, fontFamily: "medium"),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebPageView(controller: cookiesWebViewController,webPageTitle: "Direct Emploi - Charte cookies",)));
              },
          ),
          ListTile(
            title: Text(
              "FAQ (questions fréquentes)",
              style: TextStyle(fontSize: 15, fontFamily: "medium"),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebPageView(controller: faqWebViewController,webPageTitle: "Direct Emploi - FAQ (questions fréquentes)",)));
              },
          ),
          ListTile(
            title: Text(
              "Contact",
              style: TextStyle(fontSize: 15, fontFamily: "medium"),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebPageView(controller: contactWebViewController,webPageTitle: "Direct Emploi - Contact",)));
              },
          ),
        ],
      ),
    );
  }
}

class RightDrawer extends StatelessWidget {
  UserManager userManager = UserManager.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(builder: (context, profileViewModel, child) {

      final isProfileVisible = profileViewModel.userCompetences?.isProfileVisible ?? 0;
      final isNewsletterSubscribed = profileViewModel.personalInfo?.aboNews ?? 0;
      final userPassword = profileViewModel.personalInfo?.passCrypt;

      return Drawer(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 25.0),
              child: Text("Paramétres", style: TextStyle(fontSize: 20, fontFamily: "semi-bold")),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Opacity(
                opacity: profileViewModel.profileCompletionData?["userSituation"] == false ? 0.6 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Rendre mon profil visible",
                            style: TextStyle(fontSize: 15, fontFamily: "medium", color: textColor)),
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            activeColor: appColor,
                            value: isProfileVisible == 1 ? true : false,
                            onChanged: (value) {
                              profileViewModel.toggleProfileVisibility();
                            },
                          ),
                        )
                      ],
                    ),
                    profileViewModel.profileCompletionData?["userSituation"] == false
                        ? Text("Vous devez remplir votre situtation.", style: TextStyle(fontSize: 12))
                        : SizedBox(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("M'abonner aux newsletter",
                      style: TextStyle(fontSize: 15, fontFamily: "medium", color: textColor)),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeColor: appColor,
                      value: isNewsletterSubscribed == 1 ? true : false,
                      onChanged: (value) {
                        profileViewModel.toggleNewsletter();
                      },
                    ),
                  )
                ],
              ),
            ),
            // ListTile(
            //   leading: Icon(Icons.notifications, color: textColor),
            //   title: Text("Gestion des notifications",
            //       style: TextStyle(fontSize: 15, fontFamily: "medium", color: textColor)),
            //   onTap: () {
            //     // Handle tap on menu item
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.mail, color: textColor),
            //   title: Text("Gestion des emails",
            //       style: TextStyle(fontSize: 15, fontFamily: "medium", color: textColor)),
            //   onTap: () {
            //     // Handle tap on menu item
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.person, color: textColor),
            //   title: Text("Modification de profil",
            //       style: TextStyle(fontSize: 15, fontFamily: "medium", color: textColor)),
            //   onTap: () {
            //     // Handle tap on menu item
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.lock, color: textColor),
              title: userPassword == null
                  ? Text("Création mot de passe",
                  style: TextStyle(fontSize: 15, fontFamily: "medium", color: textColor))
                  : Text("Modification mot de passe",
                  style: TextStyle(fontSize: 15, fontFamily: "medium", color: textColor)),
              onTap: () {
                if (userPassword == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreatePasswordScreen()),
                  ).then((val) {
                    if (val == true) {
                      _refreshPersonalInfoFetch(context);
                      print("test");
                    }
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                  ).then((val) {
                    if (val == true) {
                      _refreshPersonalInfoFetch(context);
                    }
                  });
                }
              },
            ),
            Spacer(),
            Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: Divider()),
            ListTile(
              leading: Icon(Icons.logout, color: textColor),
              title: Text("Me déconnecter",
                  style: TextStyle(fontSize: 15, fontFamily: "medium", color: textColor)),
              onTap: () {
                if (userPassword == null) {
                  _confirmDisconnect(context);
                } else {
                  UserManager usermanager = UserManager.instance;
                  usermanager.clearUserId();
                  usermanager.clearToken();
                  Navigator.pushNamedAndRemoveUntil(context, "/splash-screen", (r) => false);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_forever, color: Colors.red),
              title: Text("Supprimer mon compte",
                  style: TextStyle(fontSize: 15, fontFamily: "medium", color: Colors.red)),
              onTap: () {
                _confirmDeleteAccount(context);
              },
            ),
          ],
        ),
      );
    });
  }

  Future<void> _refreshPersonalInfoFetch(BuildContext context) async {
    print('Refreshing Personal Info');
    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
    await viewModel.fetchPersonalInfo(userManager.userId!);
    print('Finished Refreshing Personal Info');
  }

  Future<void> _confirmDisconnect(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Êtes-vous sûr de vouloir déconnecter ?'),
        content: Text('Vous risquez de perdre vos données lorsque vous vous déconnectez sans créer un mot de passe.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Rester connecté'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Poursuivre la deconnexion'),
          ),
        ],
      ),
    );

    if (result == true) {
      UserManager usermanager = UserManager.instance;
      usermanager.clearUserId();
      usermanager.clearToken();
      Navigator.pushNamedAndRemoveUntil(context, "/splash-screen", (r) => false);
    }
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);

    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Êtes-vous sûr de vouloir supprimer votre compte ?'),
        content: Text('Cette action est irréversible et supprimera toutes vos données.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Supprimer'),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        await viewModel.deleteUserAccount(userManager.userId!);
        Navigator.pushNamedAndRemoveUntil(context, "/splash-screen", (r) => false);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete account: $e')),
        );
      }
    }
  }
}
