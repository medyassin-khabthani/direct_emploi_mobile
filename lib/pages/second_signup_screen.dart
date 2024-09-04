import 'package:direct_emploi/pages/third_signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../datas/de_datas.dart';
import '../viewmodels/signup_view_model.dart';
import '../viewmodels/data_fetching_view_model.dart';
import '../helper/de_dropdown_map.dart';
import '../helper/de_text_field.dart';
import '../helper/style.dart';

class SecondSignupScreen extends StatefulWidget {
  @override
  _SecondSignupScreenState createState() => _SecondSignupScreenState();
}

class _SecondSignupScreenState extends State<SecondSignupScreen> {
  TextEditingController posteController = TextEditingController();
  final TextEditingController competenceController = TextEditingController();
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
  int? selectedContratSouhaite;
  int? selectedFourchetteRemunerationSouhaite;
  int permisB = 1;
  int isProfileVisible = 1;
  int isProfileAnonyme = 1;
  int isCvVisible = 1;
  static const List<String> switchList = <String>['Oui','Non'];

  void _registerStep2() async {
    final viewModel = Provider.of<SignupViewModel>(context, listen: false);

    if (competenceController.text.isEmpty || posteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }

    Map<String, dynamic> data = {
      'posteActuel': posteController.text,
      'idSecteurActivitePoste': selectedSecteurActivitePoste,
      'experience': selectedSituationExperience,
      'remuneration': selectedFourchetteRemuneration,
      'disponibilite': selectedDisponibilite,
      'mobilite': selectedMobilite,
      'activite': selectedSituationActivite,
      'competence': competenceController.text,
      'langue1': selectedLangue1,
      'niveau1': selectedNiveauLangue1,
      'langue2': selectedLangue2,
      'niveau2': selectedNiveauLangue2,
      'permisB': permisB,
      'profil_visible': isProfileVisible,
      'profil_anonyme': isProfileAnonyme,
      'cv_visible': isCvVisible,
    };

    bool success = await viewModel.registerStep2(data);
    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ThirdSignupScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Step 2 registration failed. Please try again.')),
      );
    }
  }

  @override
  void initState() {
    final dataFetchingViewModel = Provider.of<DataFetchingViewModel>(context, listen: false);
    dataFetchingViewModel.fetchFourchetteRemuneration();
    dataFetchingViewModel.fetchSecteurActivites();

    dataFetchingViewModel.fetchSituationActivites();
    dataFetchingViewModel.fetchSituationExperiences();
    dataFetchingViewModel.fetchDisponibilite();
    dataFetchingViewModel.fetchMobilite();
    dataFetchingViewModel.fetchLangues();
    dataFetchingViewModel.fetchNiveauxLangue();
    selectedFourchetteRemuneration = 1;
    selectedSituationActivite = 1;
    selectedSituationExperience = 1;
    selectedDisponibilite = 1 ;
    selectedMobilite = 237;
    selectedSecteurActivitePoste = 55;

    selectedLangue1 = 1;
    selectedNiveauLangue1 = 2;
    selectedLangue2 = 1;
    selectedNiveauLangue2 = 2;

    selectedContratSouhaite = 2;
    selectedFourchetteRemunerationSouhaite = 1;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: headerBackground,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Etape 2: Définir mon profil",
          style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold'),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Consumer2<DataFetchingViewModel,SignupViewModel>(
          builder: (context, dataFetchingViewModel,viewModel, child) {
            if (dataFetchingViewModel.isLoadingSituationExperiences || dataFetchingViewModel.isLoadingFourchette || dataFetchingViewModel.isLoadingDisponibilite || dataFetchingViewModel.isLoadingLangues || dataFetchingViewModel.isLoadingMobilite || dataFetchingViewModel.isLoadingSituationActivites || dataFetchingViewModel.isLoadingSituationExperiences ){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Votre Situation actuelle", style: TextStyle(fontSize: 16, fontFamily: 'semi-bold')),
                const SizedBox(height: 20),
                DETextField(
                  controller: posteController,
                  labelText: 'Poste actuel (ou dernier poste)',
                ),
                const SizedBox(height: 20),
                DEDropdownMap(
                  labelText: 'Secteur d\'activite du poste',
                  items: dataFetchingViewModel.secteurActivites,
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
                  items: dataFetchingViewModel.fourchettes,
                  onChanged: (value) {
                    setState(() {
                      selectedFourchetteRemuneration = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                DEDropdownMap(
                  labelText: 'Activité',
                  items: dataFetchingViewModel.situationActivites,
                  onChanged: (value) {
                    setState(() {
                      selectedSituationActivite = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                DEDropdownMap(
                  labelText: 'Nombre d\'années d\'expérience',
                  items: dataFetchingViewModel.situationExperiences,
                  onChanged: (value) {
                    setState(() {
                      selectedSituationExperience = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                DEDropdownMap(
                  labelText: 'Disponibilité',
                  items: dataFetchingViewModel.disponibilites,
                  onChanged: (value) {
                    setState(() {
                      selectedDisponibilite = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                DEDropdownMap(
                  labelText: 'Mobilité',
                  items: dataFetchingViewModel.mobilites,
                  onChanged: (value) {
                    setState(() {
                      selectedMobilite = value;
                    });
                  },
                ),
                const SizedBox(height: 30),
                Text("Vos compétences", style: TextStyle(fontSize: 16, fontFamily: 'semi-bold')),
                const SizedBox(height: 20),
                DETextField(controller: competenceController, labelText: "Liste des compétences"),
                const SizedBox(height: 20),
                DEDropdownMap(
                  labelText: 'Langue étrangère 1',
                  items: dataFetchingViewModel.langues,
                  onChanged: (value) {
                    setState(() {
                      selectedLangue1 = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                DEDropdownMap(
                  labelText: 'Niveau',
                  items: dataFetchingViewModel.niveaux,
                  onChanged: (value) {
                    setState(() {
                      selectedNiveauLangue1 = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                DEDropdownMap(
                  labelText: 'Langue étrangère 2',
                  items: dataFetchingViewModel.langues,
                  onChanged: (value) {
                    setState(() {
                      selectedLangue2 = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                DEDropdownMap(
                  labelText: 'Niveau',
                  items: dataFetchingViewModel.niveaux,
                  onChanged: (value) {
                    setState(() {
                      selectedNiveauLangue2 = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Permis B", style: TextStyle(fontFamily: 'medium')),
                    SizedBox(width: 10),
                    ToggleSwitch(

                      minWidth: 60.0,
                      minHeight: 35.0,
                      fontSize: 14.0,
                      initialLabelIndex: permisB == 1 ? 0 : 1,

                      activeBgColor: [appColor],
                      activeFgColor: Colors.white,
                      inactiveBgColor: headerBackground,
                      inactiveFgColor: appColor,
                      totalSwitches: 2,
                      labels: switchList,
                      onToggle: (index) {
                        print(index);
                        setState(() {
                          permisB = index == 1 ? 0 : 1;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text("Votre recherche d'emploi", style: TextStyle(fontSize: 16, fontFamily: 'semi-bold')),
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
                const SizedBox(height: 20),
                DEDropdownMap(
                  labelText: 'Salaire souhaité',
                  items: dataFetchingViewModel.fourchettes,
                  onChanged: (value) {
                    setState(() {
                      selectedFourchetteRemunerationSouhaite = value;
                    });
                  },
                ),
                const SizedBox(height: 30),
                Text("Paramètres de confidentialité", style: TextStyle(fontSize: 16, fontFamily: 'semi-bold')),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text("Rendre mon profil visible (votre profil sera consultable par les recruteurs)", style: TextStyle(fontFamily: 'medium'))),
                    SizedBox(width: 10),
                    ToggleSwitch(
                      minWidth: 60.0,
                      minHeight: 35.0,
                      fontSize: 14.0,
                      initialLabelIndex: isProfileVisible == 1 ? 0 : 1,

                      activeBgColor: [appColor],
                      activeFgColor: Colors.white,
                      inactiveBgColor: headerBackground,
                      inactiveFgColor: appColor,
                      totalSwitches: 2,
                      labels: ['Oui', 'Non'],
                      onToggle: (index) {
                        setState(() {
                          isProfileVisible = index == 1 ? 0 : 1;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text("Rendre mon profil anonyme (vos informations civiles seront masquées, veilliez à utiliser un CV anonyme)", style: TextStyle(fontFamily: 'medium'))),
                    SizedBox(width: 10),
                    ToggleSwitch(
                      minWidth: 60.0,
                      minHeight: 35.0,
                      fontSize: 14.0,
                      initialLabelIndex: isProfileAnonyme == 1 ? 0 : 1,

                      activeBgColor: [appColor],
                      activeFgColor: Colors.white,
                      inactiveBgColor: headerBackground,
                      inactiveFgColor: appColor,
                      totalSwitches: 2,
                      labels: ['Oui', 'Non'],
                      onToggle: (index) {
                        setState(() {
                          isProfileAnonyme = index == 1 ? 0 : 1;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text("Rendre mon CV visible (les recruteurs pourront télécharger votre CV)", style: TextStyle(fontFamily: 'medium'))),
                    SizedBox(width: 10),
                    ToggleSwitch(
                      minWidth: 60.0,
                      minHeight: 35.0,
                      fontSize: 14.0,
                      initialLabelIndex: isCvVisible == 1 ? 0 : 1,

                      activeBgColor: [appColor],
                      activeFgColor: Colors.white,
                      inactiveBgColor: headerBackground,
                      inactiveFgColor: appColor,
                      totalSwitches: 2,
                      labels: ['Oui', 'Non'],
                      onToggle: (index) {
                        setState(() {
                          isCvVisible = index == 1 ? 0 : 1;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: appButton(),
                  onPressed:viewModel.isLoading ? null : _registerStep2,
                  child:viewModel.isLoading
                      ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : Text("Valider et continuer"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
