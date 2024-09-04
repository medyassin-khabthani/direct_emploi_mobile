import 'package:direct_emploi/datas/de_datas.dart';
import 'package:direct_emploi/helper/de_back_button.dart';
import 'package:direct_emploi/viewmodels/data_fetching_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/de_drop_down.dart';
import '../helper/de_dropdown_map.dart';
import '../helper/de_text_field.dart';
import '../helper/style.dart';
import '../viewmodels/profile_view_model.dart';

class SituationScreen extends StatefulWidget {
  const SituationScreen({super.key});

  @override
  State<SituationScreen> createState() => _SituationScreenState();
}

class _SituationScreenState extends State<SituationScreen> {
  TextEditingController diplomeController = TextEditingController();
  TextEditingController nomDiplomeController = TextEditingController();
  TextEditingController posteController = TextEditingController();
  TextEditingController competenceController = TextEditingController();
  int? selectedMetier;
  int? selectedFormation;
  int? selectedEtablissement;
  int? selectedSecteurActivite;
  int? selectedSecteurActivitePoste;
  int? selectedFourchetteRemuneration;
  int? selectedSituationActivite;
  int? selectedSituationExperience;
  int? selectedDisponibilite;
  int? selectedMobilite;
  int? selectedLangue1;
  int? selectedNiveauLangue1;
  int? selectedLangue2;
  int? selectedNiveauLangue2;
  int? permisB;
  String? based;
  String? configId;

  @override
  void initState() {
    super.initState();
    final dataFetchingViewModel =
        Provider.of<DataFetchingViewModel>(context, listen: false);
    dataFetchingViewModel.fetchAllDropdownData();

    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);

    profileViewModel.getUserConfiguration().then((_) {
      if (profileViewModel.userConfiguration != null) {
        setState(() {
          based =
              profileViewModel.userConfiguration!.configuration.based ?? 'none';
          configId = profileViewModel.userConfiguration!.id;
        });
      }
    });

    if (profileViewModel.profileCompletionData?['userSituation'] == true) {
      profileViewModel
          .fetchUserSituationAndCompetences(
              profileViewModel.userManager.userId!)
          .then((_) {
        setState(() {
          final userSituation = profileViewModel.userSituation;
          final userCompetences = profileViewModel.userCompetences;

          if (userSituation != null) {
            dataFetchingViewModel
                .fetchMetiersBySecteur(userSituation.idSecteurActivite!);
            dataFetchingViewModel
                .fetchEtablissementsByFormation(userSituation.idTypeFormation!);


            selectedSecteurActivite = userSituation.idSecteurActivite ?? 55;
            selectedMetier = userSituation.idMetier ?? 803;
            selectedFormation = userSituation.idTypeFormation ?? 23;
            if (userSituation.idEtablissement == null){
              selectedEtablissement = dataFetchingViewModel.etablissements.keys.first;

            }else{
              selectedEtablissement = userSituation.idEtablissement ?? 0;

            }
            if (userSituation.nomDiplome == '0') {
              nomDiplomeController.text = '';
            } else {
              nomDiplomeController.text = userSituation.nomDiplome!;
            }
            if (userSituation.anneDiplome == '0') {
              diplomeController.text = '';
            } else {
              diplomeController.text = userSituation.anneDiplome!;
            }
            if (userSituation.posteActuel == '0') {
              posteController.text = '';
            } else {
              posteController.text = userSituation.posteActuel!;
            }
            if (userSituation.idSecteurActivitePoste == 0) {
              selectedSecteurActivitePoste = 55;
            } else {
              selectedSecteurActivitePoste =
                  userSituation.idSecteurActivitePoste;
            }
            selectedFourchetteRemuneration =
                userSituation.idFourchetteRemuneration ?? 1;
            selectedSituationActivite = userSituation.idSituationActivite ?? 1;
            selectedSituationExperience =
                userSituation.idSituationExperience ?? 1;
            selectedDisponibilite = userSituation.idDisponibilite ?? 1;
            selectedMobilite = userSituation.idMobilite ?? 237;
          }

          if (userCompetences != null) {
            competenceController.text = userCompetences.competences ?? '';
            selectedLangue1 = userCompetences.idChoixLangue1 ?? 1;
            selectedNiveauLangue1 = userCompetences.idNiveauLangue1 ?? 2;
            selectedLangue2 = userCompetences.idChoixLangue2 ?? 1;
            selectedNiveauLangue2 = userCompetences.idNiveauLangue2 ?? 2;
            permisB = userCompetences.permisB ?? 0;
          }
        });
      });
    } else {
      dataFetchingViewModel.fetchMetiersBySecteur(55);
      dataFetchingViewModel.fetchEtablissementsByFormation(23);
      selectedSecteurActivite = 55;
      selectedFormation = 23;
      selectedSecteurActivitePoste = 55;
      selectedFourchetteRemuneration = 1;
      selectedSituationActivite = 1;
      selectedSituationExperience = 1;
      selectedDisponibilite = 1;
      selectedMobilite = 237;
      selectedMetier = 803;
      selectedEtablissement = 0;
      selectedLangue1 = 1;
      selectedNiveauLangue1 = 2;
      selectedLangue2 = 1;
      selectedNiveauLangue2 = 2;
      permisB = 0;
    }

    print("selectedEtablissement $selectedEtablissement");
  }

  @override
  void dispose() {
    diplomeController.dispose();
    nomDiplomeController.dispose();
    posteController.dispose();
    competenceController.dispose();
    super.dispose();
  }

  void _updateSituation() async {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    Map<String, dynamic> data = {
      "idSecteurActivite": selectedSecteurActivite,
      "idMetier": selectedMetier,
      "idTypeFormation": selectedFormation,
      "idEtablissement": selectedEtablissement,
      "nomDiplome": nomDiplomeController.text,
      "anneDiplome": diplomeController.text,
      "posteActuel": posteController.text,
      "idSecteurActivitePoste": selectedSecteurActivitePoste,
      "idFourchetteRemuneration": selectedFourchetteRemuneration,
      "idSituationActivite": selectedSituationActivite,
      "idSituationExperience": selectedSituationExperience,
      "idDisponibilite": selectedDisponibilite,
      "idMobilite": selectedMobilite,
      "competences": competenceController.text,
      "idChoixLangue1": selectedLangue1,
      "idNiveauLangue1": selectedNiveauLangue1,
      "idChoixLangue2": selectedLangue2,
      "idNiveauLangue2": selectedNiveauLangue2,
      "permisB": permisB,
    };

    if (based == 'profil') {
      profileViewModel.updateUserConfiguration(configId!, {
        "based": "profil",
        "q": posteController.text,
        "localisation": regions[profileViewModel.userSituation!.idMobilite]
      });
    }

    await profileViewModel.updateUserSituation(data);
    if (profileViewModel.isError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Une erreur est survenue lors de la mise à jour de votre situation')),
      );
    } else {
      Navigator.pop(context, true);
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
          "Ma situation",
          style: TextStyle(
              fontSize: 14, color: textColor, fontFamily: 'semi-bold'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Consumer2<DataFetchingViewModel, ProfileViewModel>(
              builder: (context, viewModel, profileViewModel, child) {
                if (viewModel.isLoading ||
                    viewModel.isLoadingMetier ||
                    viewModel.isLoadingEtablissement) {
                  return Center(child: CircularProgressIndicator());
                } else if (viewModel.error != null) {
                  return Center(child: Text('Une erreur est survenue'));
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Votre domaine d'activité et votre formation",
                        style: TextStyle(
                            fontSize: 14,
                            color: textColor,
                            fontFamily: 'semi-bold'),
                      ),
                      Divider(),
                      const SizedBox(height: 20),
                      DEDropdownMap(
                        labelText: 'Domaine d\'activité de l\'entreprise',
                        items: viewModel.secteurActivites,
                        forcedSelectedKey: selectedSecteurActivite ?? 55,
                        initialKey: selectedSecteurActivite ?? 55,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedSecteurActivite = value;
                            });
                            viewModel.fetchMetiersBySecteur(value).then((_) {
                              setState(() {
                                selectedMetier = viewModel.metiers.keys.first;
                              });
                            });
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      DEDropdownMap(
                        labelText: 'Métier',
                        forcedSelectedKey: selectedMetier,
                        initialKey: selectedMetier,
                        items: viewModel.metiers.isNotEmpty
                            ? viewModel.metiers
                            : {},
                        onChanged: (value) {
                          setState(() {
                            selectedMetier = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      DEDropdownMap(
                        labelText: 'Niveau de formation',
                        items: formationOption,
                        forcedSelectedKey: selectedFormation ?? 23,
                        initialKey: selectedFormation ?? 23,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedFormation = value;
                            });
                            viewModel
                                .fetchEtablissementsByFormation(value)
                                .then((_) {
                              setState(() { if (value != 23){
                                selectedEtablissement =
                                    viewModel.etablissements.keys.first;
                              }else{
                                selectedEtablissement = 0;
                              }


                              });
                            });
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      DEDropdownMap(
                        labelText: 'Etablissement / Spécialité',
                        forcedSelectedKey: selectedEtablissement,
                        initialKey: selectedEtablissement,
                        items: viewModel.etablissements.isNotEmpty
                            ? viewModel.etablissements
                            : {},
                        onChanged: (value) {
                          setState(() {
                            selectedEtablissement = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      Stack(
                          alignment: AlignmentDirectional.centerEnd,
                          children: [
                            DETextField(
                              controller: nomDiplomeController,
                              labelText: 'Nom du diplome',
                            ),
                            if (selectedEtablissement != 0 &&
                                selectedFormation != 23 && nomDiplomeController.text.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Icon(
                                  Icons.circle,
                                  color: yellowDot,
                                  size: 10,
                                ),
                              ),
                          ]),
                      SizedBox(height: 20),
                      Stack(
                          alignment: AlignmentDirectional.centerEnd,

                          children: [
                        DETextField(
                          controller: diplomeController,
                          labelText: 'Année d\'obtention du diplôme',
                        ),
                        if (selectedEtablissement != 0 &&
                            selectedFormation != 23 && diplomeController.text.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Icon(
                              Icons.circle,
                              color: yellowDot,
                              size: 10,
                            ),
                          ),
                      ]),
                      const SizedBox(height: 40),
                      Text(
                        "Votre situation actuelle",
                        style: TextStyle(
                            fontSize: 14,
                            color: textColor,
                            fontFamily: 'semi-bold'),
                      ),
                      Divider(),
                      const SizedBox(height: 20),
                      DETextField(
                        controller: posteController,
                        labelText: 'Poste actuel (ou dernier poste)',
                      ),
                      const SizedBox(height: 20),
                      DEDropdownMap(
                        labelText: 'Secteur d\'activite du poste',
                        items: viewModel.secteurActivites,
                        forcedSelectedKey: selectedSecteurActivitePoste ?? 55,
                        initialKey: selectedSecteurActivitePoste ?? 55,
                        onChanged: (value) {
                          setState(() {
                            selectedSecteurActivitePoste = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      DEDropdownMap(
                        labelText: 'Salaire du poste',
                        items: viewModel.fourchettes,
                        forcedSelectedKey: selectedFourchetteRemuneration ?? 1,
                        initialKey: selectedFourchetteRemuneration ?? 1,
                        onChanged: (value) {
                          setState(() {
                            selectedFourchetteRemuneration = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      DEDropdownMap(
                        labelText: 'Activité',
                        items: viewModel.situationActivites,
                        forcedSelectedKey: selectedSituationActivite ?? 1,
                        initialKey: selectedSituationActivite ?? 1,
                        onChanged: (value) {
                          setState(() {
                            selectedSituationActivite = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      DEDropdownMap(
                        labelText: 'Nombre d\'années d\'expérience',
                        items: viewModel.situationExperiences,
                        forcedSelectedKey: selectedSituationExperience ?? 1,
                        initialKey: selectedSituationExperience ?? 1,
                        onChanged: (value) {
                          setState(() {
                            selectedSituationExperience = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      DEDropdownMap(
                        labelText: 'Disponibilité',
                        items: viewModel.disponibilites,
                        forcedSelectedKey: selectedDisponibilite ?? 1,
                        initialKey: selectedDisponibilite ?? 1,
                        onChanged: (value) {
                          setState(() {
                            selectedDisponibilite = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      DEDropdownMap(
                        labelText: 'Mobilité',
                        items: viewModel.mobilites,
                        forcedSelectedKey: selectedMobilite ?? 237,
                        initialKey: selectedMobilite ?? 237,
                        onChanged: (value) {
                          setState(() {
                            selectedMobilite = value;
                          });
                        },
                      ),
                      SizedBox(height: 40),
                      Text(
                        "Vos compétences",
                        style: TextStyle(
                            fontSize: 14,
                            color: textColor,
                            fontFamily: 'semi-bold'),
                      ),
                      Divider(),
                      SizedBox(height: 20),
                      DETextField(
                        controller: competenceController,
                        labelText:
                            'Liste des compétences (word, powerpoint, etc..)',
                      ),
                      SizedBox(height: 20),
                      DEDropdownMap(
                        labelText: 'Langue étrangère 1',
                        items: viewModel.langues,
                        forcedSelectedKey: selectedLangue1 ?? 1,
                        initialKey: selectedLangue1 ?? 1,
                        onChanged: (value) {
                          setState(() {
                            selectedLangue1 = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      DEDropdownMap(
                        labelText: 'Niveau',
                        items: viewModel.niveaux,
                        forcedSelectedKey: selectedNiveauLangue1 ?? 2,
                        initialKey: selectedNiveauLangue1 ?? 2,
                        onChanged: (value) {
                          setState(() {
                            selectedNiveauLangue1 = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      DEDropdownMap(
                        labelText: 'Langue étrangère 2',
                        items: viewModel.langues,
                        forcedSelectedKey: selectedLangue2 ?? 1,
                        initialKey: selectedLangue2 ?? 1,
                        onChanged: (value) {
                          setState(() {
                            selectedLangue2 = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      DEDropdownMap(
                        labelText: 'Niveau',
                        items: viewModel.niveaux,
                        forcedSelectedKey: selectedNiveauLangue2 ?? 2,
                        initialKey: selectedNiveauLangue2 ?? 2,
                        onChanged: (value) {
                          setState(() {
                            selectedNiveauLangue2 = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      DEDropdownMap(
                        labelText: 'Permis B',
                        items: ouiNonOption,
                        forcedSelectedKey: permisB ?? 0,
                        initialKey: permisB ?? 0,
                        onChanged: (value) {
                          setState(() {
                            permisB = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: appButton(),
                        onPressed: profileViewModel.isLoading
                            ? null
                            : _updateSituation,
                        child: profileViewModel.isLoading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text("Modifier ma situation"),
                      ),
                      SizedBox(height: 20),
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
