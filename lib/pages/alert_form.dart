import 'package:direct_emploi/viewmodels/alerts_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../datas/de_datas.dart';
import '../viewmodels/signup_view_model.dart';
import '../viewmodels/data_fetching_view_model.dart';
import '../helper/de_dropdown_map.dart';
import '../helper/de_text_field.dart';
import '../helper/style.dart';

class AlertForm extends StatefulWidget {
  @override
  _AlertFormState createState() => _AlertFormState();
}

class _AlertFormState extends State<AlertForm> {
  final TextEditingController alerteController = TextEditingController();
  int? selectedContratSouhaite;
  int? selectedExperienceAlert;
  int? selectedDomaineAlert;
  int? selectedRegionAlert;
  int? selectedMetierAlert;
  int? selectedDepartementAlert;
  bool handicapCB = false;
  int selectedHandicap = 0;

  void _createAlert() async {
    final viewModel = Provider.of<AlertsViewModel>(context, listen: false);
    if (alerteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }
    Map<String, dynamic> data = {
      'nom_alerte': alerteController.text,
      'contrat': selectedContratSouhaite,
      'experience': selectedExperienceAlert,
      'domaine_activite': selectedDomaineAlert,
      'geo_liste_region': selectedRegionAlert,
      'metier_metier': selectedMetierAlert,
      'geo_departement': selectedDepartementAlert,
      'handi': selectedHandicap,
    };

    bool success = await viewModel.createAlert(data);
    if (success) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Step 3 registration failed. Please try again.')),
      );
    }
  }

  @override
  void initState() {
    final dataFetchingViewModel = Provider.of<DataFetchingViewModel>(context, listen: false);
    dataFetchingViewModel.fetchSecteurActivites();
    dataFetchingViewModel.fetchSituationExperiences();
    dataFetchingViewModel.fetchListePays();
    dataFetchingViewModel.fetchDepartementsByRegion(12);
    dataFetchingViewModel.fetchMetiersBySecteurAlert(55);

    selectedContratSouhaite = 2;
    selectedExperienceAlert = 1;
    selectedRegionAlert = 12;
    selectedDomaineAlert = 55;
    selectedDepartementAlert = 286;
    selectedMetierAlert = 803;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Consumer2<DataFetchingViewModel,AlertsViewModel>(
        builder: (context, dataFetchingViewModel,alertViewModel, child) {
          if (dataFetchingViewModel.isLoadingSituationExperiences || dataFetchingViewModel.isLoadingSecteur || dataFetchingViewModel.isLoadingPays) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Création / Édition d'une alerte mail", style: TextStyle(fontSize: 16, fontFamily: 'semi-bold')),
              const SizedBox(height: 20),
              DETextField(controller: alerteController, labelText: "Nom de mon alerte"),
              const SizedBox(height: 20),
              DEDropdownMap(
                labelText: 'Type de contrat souhaité',
                items: contratOptionsInt,
                onChanged: (value) {
                  setState(() {
                    selectedContratSouhaite = value;
                  });
                },
              ),
              SizedBox(height: 20),
              DEDropdownMap(
                labelText: 'Experience',
                items: dataFetchingViewModel.situationExperiences,
                onChanged: (value) {
                  setState(() {
                    selectedExperienceAlert = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              DEDropdownMap(
                labelText: 'Domaine de votre métier',
                items: dataFetchingViewModel.secteurActivites,
                onChanged: (value) {
                  setState(() {
                    selectedDomaineAlert = value;
                  });
                  dataFetchingViewModel.fetchMetiersBySecteurAlert(value!).then((_) {
                    setState(() {
                      selectedMetierAlert = dataFetchingViewModel.metiersAlert.keys.first;
                    });
                  });
                },
              ),
              const SizedBox(height: 20),
              DEDropdownMap(
                labelText: 'Région',
                items: regions,
                onChanged: (value) {
                  setState(() {
                    selectedRegionAlert = value;
                  });
                  dataFetchingViewModel.fetchDepartementsByRegion(value!).then((_) {
                    setState(() {
                      selectedDepartementAlert = dataFetchingViewModel.departements.keys.first;
                    });
                  });
                },
              ),
              const SizedBox(height: 20),
              DEDropdownMap(
                labelText: 'Métier',
                forcedSelectedKey: selectedMetierAlert,
                initialKey: selectedMetierAlert,
                items: dataFetchingViewModel.metiersAlert.isNotEmpty ? dataFetchingViewModel.metiersAlert : {},
                onChanged: (value) {
                  setState(() {
                    selectedMetierAlert = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              DEDropdownMap(
                labelText: 'Département',
                forcedSelectedKey: selectedDepartementAlert,
                initialKey: selectedDepartementAlert,
                items: dataFetchingViewModel.departements.isNotEmpty ? dataFetchingViewModel.departements : {},
                onChanged: (value) {
                  setState(() {
                    selectedDepartementAlert = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: strokeColor,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "N'afficher que les offres ouvertes aux personnes en situation de handicap",
                            style: TextStyle(fontSize: 14, fontFamily: "medium"),
                          ),
                        ),
                        Checkbox(
                          activeColor: appColor,
                          value: handicapCB,
                          onChanged: (bool? value) {
                            setState(() {
                              handicapCB = !handicapCB;
                            });
                            if (handicapCB == true) {
                              setState(() {
                                selectedHandicap = 1;
                              });
                            } else {
                              selectedHandicap = 0;
                            }
                            print(selectedHandicap);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: appButton(),
                onPressed:alertViewModel.isLoading ? null : _createAlert,
                child:alertViewModel.isLoading
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : Text("Enregistrer l'alerte"),
              ),
            ],
          );
        },
      ),
    );
  }
}
