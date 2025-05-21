import 'package:flutter/material.dart';
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
import '../viewmodels/profile_view_model.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  // ---------------------------------------------------------------------------
  // Text Controllers
  // ---------------------------------------------------------------------------
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController compAdresseController = TextEditingController();
  final TextEditingController postalController = TextEditingController();
  final TextEditingController villeController = TextEditingController();

  // ---------------------------------------------------------------------------
  // Selections
  // ---------------------------------------------------------------------------
  int? selectedPays;
  int? selectedCivilite;

  /// Whether we have set the text fields from the loaded PersonalInfo yet
  bool _fieldsInitialized = false;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    // 1) Fetch the list of countries
    final dataVM = Provider.of<DataFetchingViewModel>(context, listen: false);
    dataVM.fetchListePays();

    // 2) Fetch the user's personal info
    final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
    profileVM.fetchPersonalInfo(UserManager.instance.userId!);

    // If user has no personal info, set some defaults
    if (profileVM.profileCompletionData?['userInfo'] == false) {
      selectedCivilite = 1;
      selectedPays = 1;
    }
  }

  @override
  void dispose() {
    prenomController.dispose();
    nomController.dispose();
    telephoneController.dispose();
    emailController.dispose();
    adresseController.dispose();
    compAdresseController.dispose();
    postalController.dispose();
    villeController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Build Method
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0,
        centerTitle: true,
        leading: const DEBackButton(),
        title: const Text(
          "Mes informations personnelles",
          style: TextStyle(
            fontSize: 14,
            color: textColor,
            fontFamily: 'semi-bold',
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Consumer2<ProfileViewModel, DataFetchingViewModel>(
              builder: (context, profileVM, dataVM, child) {
                // Show loading if needed
                if (profileVM.isLoadingPersonal || dataVM.isLoadingPays) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Show error if any
                if (profileVM.error != null || dataVM.error != null) {
                  return const Center(child: Text('Failed to load data'));
                }

                // We have personal info loaded
                final personalInfo = profileVM.personalInfo;
                // Initialize fields only once
                if (!_fieldsInitialized && personalInfo != null) {
                  _setFieldsFromPersonalInfo(personalInfo);
                  _fieldsInitialized = true;
                }

                return Column(
                  children: [
                    const SizedBox(height: 20),

                    // Civilité
                    DEDropdownMap(
                      labelText: 'Civilité',
                      items: genderOption,
                      initialKey: selectedCivilite ?? 1,
                      onChanged: (value) {
                        setState(() {
                          selectedCivilite = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Prénom
                    DETextField(
                      controller: prenomController,
                      labelText: "Prénom",
                    ),
                    const SizedBox(height: 20),

                    // Nom
                    DETextField(
                      controller: nomController,
                      labelText: "Nom",
                    ),
                    const SizedBox(height: 20),

                    // Pays
                    DEDropdownMap(
                      labelText: "Sélectionner votre pays",
                      items: dataVM.listePays,
                      initialKey: selectedPays ?? 1,
                      onChanged: (value) {
                        setState(() {
                          selectedPays = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Email
                    DETextField(
                      controller: emailController,
                      labelText: 'Email',
                    ),
                    const SizedBox(height: 20),

                    // Téléphone
                    DETextField(
                      controller: telephoneController,
                      labelText: 'Téléphone Portable',
                    ),
                    const SizedBox(height: 20),

                    // Adresse
                    DETextField(
                      controller: adresseController,
                      labelText: 'Adresse',
                    ),
                    const SizedBox(height: 20),

                    // Ville
                    DETextField(
                      controller: villeController,
                      labelText: 'Ville',
                    ),
                    const SizedBox(height: 20),

                    // Complément
                    DETextField(
                      controller: compAdresseController,
                      labelText: "Complément d'adresse (optionnel)",
                    ),
                    const SizedBox(height: 20),

                    // Code Postal
                    DETextField(
                      controller: postalController,
                      labelText: 'Code postal',
                    ),
                    const SizedBox(height: 20),

                    // Submit button
                    ElevatedButton(
                      style: appButton(),
                      onPressed: profileVM.isLoadingUpdatePersonal
                          ? null
                          : () async {
                        // Validate fields
                        if (_hasEmptyMandatoryFields()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Tous les champs sont obligatoires sauf le complément d\'adresse.',
                              ),
                            ),
                          );
                        } else if (_validateFrenchPhoneNumber(telephoneController.text) )
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Numéro invalide (format: +33X ou 0X).',
                              ),
                            ),
                          );
                        }else if (_validatePostalCode(postalController.text) )
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Le code postal doit contenir 5 chiffres.',
                              ),
                            ),
                          );
                        }
                          else {
                          await _submitPersonalInfo(profileVM);
                        }
                      },
                      child: profileVM.isLoadingUpdatePersonal
                          ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                          : const Text("Modifier mes infos"),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Updates the controllers and dropdown values from the loaded [personalInfo]
  void _setFieldsFromPersonalInfo(PersonalInfo personalInfo) {
    prenomController.text = personalInfo.prenom ?? '';
    nomController.text = personalInfo.nom ?? '';
    telephoneController.text = personalInfo.telephone ?? '';
    emailController.text = personalInfo.email ?? '';

    selectedCivilite = (personalInfo.civilite != 0)
        ? personalInfo.civilite
        : selectedCivilite; // fallback to existing or default

    if (personalInfo.geoAdresse != null) {
      adresseController.text = personalInfo.geoAdresse?.adresse ?? '';
      compAdresseController.text = personalInfo.geoAdresse?.complement ?? '';
      postalController.text = personalInfo.geoAdresse?.codePostal ?? '';
      villeController.text = personalInfo.geoAdresse?.ville ?? '';
      if (personalInfo.geoAdresse?.pays != null) {
        selectedPays = personalInfo.geoAdresse!.pays;
      }
    }
  }

  /// Checks whether any required text fields or dropdowns are empty
  bool _hasEmptyMandatoryFields() {
    print("Submitting Personal Info:");
    print("Civilité: $selectedCivilite");
    print("Nom: ${nomController.text}");
    print("Prénom: ${prenomController.text}");
    print("Téléphone: ${telephoneController.text}");
    print("Email: ${emailController.text}");
    print("Adresse: ${adresseController.text}");
    print("Complément d'adresse: ${compAdresseController.text}");
    print("Code Postal: ${postalController.text}");
    print("Ville: ${villeController.text}");
    print("Pays: $selectedPays");

    return prenomController.text.isEmpty ||
        nomController.text.isEmpty ||
        telephoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        adresseController.text.isEmpty ||
        postalController.text.isEmpty ||
        villeController.text.isEmpty ||
        selectedCivilite == null ||
        selectedPays == null;
  }
  bool _validateFrenchPhoneNumber(String? value) {
    if (value == null || !RegExp(r'^(\+33[0-9]{9}|0[0-9]{9})$').hasMatch(value)) {
      return true; //"Numéro invalide (format: +33X ou 0X)"
    }
    return false;
  }

  bool _validatePostalCode(String? value) {
    if (value == null || !RegExp(r'^\d{5}$').hasMatch(value)) {
      return true; //"Le code postal doit contenir 5 chiffres.";
    }
    return false;
  }

  /// Builds and submits the updated [PersonalInfo] to the ProfileViewModel
  Future<void> _submitPersonalInfo(ProfileViewModel profileVM) async {


    final updated = PersonalInfo(
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

    await profileVM.updatePersonalInfo(updated);

    if (!profileVM.isError) {
      // If no error, pop with success
      Navigator.pop(context, true);
    } else {
      // Show an error if needed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update personal information'),
        ),
      );
    }
  }
}
