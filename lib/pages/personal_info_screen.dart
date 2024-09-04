// import 'package:direct_emploi/datas/de_datas.dart';
// import 'package:direct_emploi/helper/de_back_button.dart';
// import 'package:direct_emploi/viewmodels/data_fetching_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../helper/de_drop_down.dart';
// import '../helper/de_dropdown_map.dart';
// import '../helper/de_text_field.dart';
// import '../helper/style.dart';
//
// class PersonalInfoScreen extends StatefulWidget {
//   const PersonalInfoScreen({super.key});
//
//   @override
//   State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
// }
//
// class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
//   final TextEditingController prenomController = TextEditingController();
//   final TextEditingController nomController = TextEditingController();
//   final TextEditingController civiliteController = TextEditingController();
//   final TextEditingController telephoneController = TextEditingController();
//   final TextEditingController adresseController = TextEditingController();
//   final TextEditingController compAdresseController = TextEditingController();
//   final TextEditingController postalController = TextEditingController();
//   final TextEditingController villeController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//
//   int? selectedPays;
//   int? selectedCivilite;
//
//   @override
//   void initState() {
//     super.initState();
//     Provider.of<DataFetchingViewModel>(context, listen: false).fetchListePays();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white70,
//         elevation: 0,
//         centerTitle: true,
//         leading: DEBackButton(),
//         title: Text(
//           "Mes informations personnels",
//           style: TextStyle(
//               fontSize: 14, color: textColor, fontFamily: 'semi-bold'),
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 15),
//           child: SingleChildScrollView(
//             child: Consumer<DataFetchingViewModel>(
//                 builder: (context, viewModel, child) {
//               if (viewModel.isLoadingPays) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (viewModel.error != null) {
//                 return Center(child: Text('Failed to load data'));
//               } else {
//                 return Column(
//                   children: [
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     DEDropdownMap(labelText: 'Civilité', items: genderOption, onChanged: (value ) {
//                       setState(() {
//                         selectedCivilite = value;
//                       });
//                     },
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     DETextField(
//                       controller: prenomController,
//                       labelText: "Prénom",
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     DETextField(
//                       controller: nomController,
//                       labelText: "Nom",
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     DEDropdownMap(
//                         labelText: "Sélectionner votre pays",
//                         items: viewModel.listePays,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedPays = viewModel.metiers.keys.first;
//                           });
//                         }),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     DETextField(
//                       controller: emailController,
//                       labelText: 'Email',
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     DETextField(
//                       controller: telephoneController,
//                       labelText: 'Téléphone Portable',
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     DETextField(
//                       controller: adresseController,
//                       labelText: 'Adresse',
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     DETextField(
//                       controller: villeController,
//                       labelText: 'Ville',
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     DETextField(
//                       controller: compAdresseController,
//                       labelText: "Complément d'adresse (optionnel)",
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     DETextField(
//                       controller: postalController,
//                       labelText: 'Code postal',
//                     ),
//
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     ElevatedButton(
//                       style: appButton(),
//                       onPressed: () {},
//                       child: Text("Modifier mes infos"),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                   ],
//                 );
//               }
//             }),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:direct_emploi/viewmodels/profile_view_model.dart';
import 'package:provider/provider.dart';

import '../datas/de_datas.dart';
import '../helper/de_back_button.dart';
import '../helper/de_dropdown_map.dart';
import '../helper/de_text_field.dart';
import '../helper/style.dart';
import '../models/geo_adresse_model.dart';
import '../models/personal_info_model.dart';
import '../services/user_manager.dart';
import '../viewmodels/data_fetching_view_model.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController compAdresseController = TextEditingController();
  final TextEditingController postalController = TextEditingController();
  final TextEditingController villeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  int? selectedPays;
  int? selectedCivilite;

  @override
  void initState() {
    super.initState();
    Provider.of<DataFetchingViewModel>(context, listen: false).fetchListePays();
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    profileViewModel.fetchPersonalInfo(UserManager.instance.userId!);

    if (profileViewModel.profileCompletionData?['userInfo'] == false){
      selectedCivilite = 1;
      selectedPays = 1;

    }
  }

  void _updateTextFields(PersonalInfo personalInfo) {
    prenomController.text = personalInfo.prenom ?? '';
    nomController.text = personalInfo.nom ?? '';
    telephoneController.text = personalInfo.telephone ?? '';
    emailController.text = personalInfo.email ?? '';
    if (personalInfo.geoAdresse != null) {
      adresseController.text = personalInfo.geoAdresse!.adresse ?? '';
      compAdresseController.text = personalInfo.geoAdresse!.complement ?? '';
      postalController.text = personalInfo.geoAdresse!.codePostal ?? '';
      villeController.text = personalInfo.geoAdresse!.ville ?? '';
      if (personalInfo.geoAdresse?.pays != null) {
        selectedPays = personalInfo.geoAdresse!.pays;
      }
    }
    if (personalInfo.civilite != 0) {
      selectedCivilite = personalInfo.civilite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0,
        centerTitle: true,
        leading: DEBackButton(),
        title: Text(
          "Mes informations personnelles",
          style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Consumer2<ProfileViewModel, DataFetchingViewModel>(
              builder: (context, profileViewModel, dataFetchingViewModel, child) {
                if (profileViewModel.isLoadingPersonal || dataFetchingViewModel.isLoadingPays) {
                  return Center(child: CircularProgressIndicator());
                } else if (profileViewModel.error != null || dataFetchingViewModel.error != null) {
                  return Center(child: Text('Failed to load data'));
                } else {
                  final personalInfo = profileViewModel.personalInfo;

                  if (personalInfo != null) {
                    _updateTextFields(personalInfo);
                  }

                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      DEDropdownMap(
                        labelText: 'Civilité',
                        items: genderOption,
                        initialKey: selectedCivilite,
                        onChanged: (value) {
                          setState(() {
                            selectedCivilite = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      DETextField(
                        controller: prenomController,
                        labelText: "Prénom",
                      ),
                      const SizedBox(height: 20),
                      DETextField(
                        controller: nomController,
                        labelText: "Nom",
                      ),
                      const SizedBox(height: 20),
                      DEDropdownMap(
                        labelText: "Sélectionner votre pays",
                        items: dataFetchingViewModel.listePays,
                        initialKey: selectedPays,
                        onChanged: (value) {
                          setState(() {
                            selectedPays = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      DETextField(
                        controller: emailController,
                        labelText: 'Email',
                      ),
                      const SizedBox(height: 20),
                      DETextField(
                        controller: telephoneController,
                        labelText: 'Téléphone Portable',
                      ),
                      const SizedBox(height: 20),
                      DETextField(
                        controller: adresseController,
                        labelText: 'Adresse',
                      ),
                      const SizedBox(height: 20),
                      DETextField(
                        controller: villeController,
                        labelText: 'Ville',
                      ),
                      const SizedBox(height: 20),
                      DETextField(
                        controller: compAdresseController,
                        labelText: "Complément d'adresse (optionnel)",
                      ),
                      const SizedBox(height: 20),
                      DETextField(
                        controller: postalController,
                        labelText: 'Code postal',
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: appButton(),
                        onPressed: profileViewModel.isLoadingUpdatePersonal ? null : () async {
                          if (prenomController.text.isEmpty ||
                              nomController.text.isEmpty ||
                              telephoneController.text.isEmpty ||
                              emailController.text.isEmpty ||
                              adresseController.text.isEmpty ||
                              postalController.text.isEmpty ||
                              villeController.text.isEmpty ||
                              selectedCivilite == null ||
                              selectedPays == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(
                                  'Tous les champs sont obligatoires sauf le complément d\'adresse')),
                            );
                          } else {
                            final personalInfo = PersonalInfo(
                              civilite: selectedCivilite,
                              nom: nomController.text,
                              prenom: prenomController.text,
                              telephone: telephoneController.text,
                              email: emailController.text,
                              geoAdresse: GeoAdresse(
                                adresse: adresseController.text,
                                complement: compAdresseController.text,
                                codePostal: postalController.text,
                                ville: villeController.text,
                                pays: selectedPays,
                              ),
                            );

                            final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
                            await profileViewModel.updatePersonalInfo(personalInfo);

                            if (!profileViewModel.isError) {
                              Navigator.pop(context, true);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to update personal information')),
                              );
                            }
                          }
                        },
                        child:profileViewModel.isLoadingUpdatePersonal
                            ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                            : Text("Modifier mes infos"),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}