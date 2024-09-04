import 'dart:io';
import 'package:dio/dio.dart';
import 'package:direct_emploi/pages/second_signup_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../datas/de_datas.dart';
import '../helper/webpage_view.dart';
import '../viewmodels/signup_view_model.dart';
import '../viewmodels/data_fetching_view_model.dart';
import '../helper/de_dropdown_map.dart';
import '../helper/de_text_field.dart';
import '../helper/style.dart';

class FirstSignupScreen extends StatefulWidget {
  @override
  _FirstSignupScreenState createState() => _FirstSignupScreenState();
}

class _FirstSignupScreenState extends State<FirstSignupScreen> {
  File? _pickedFile;
  bool _isPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;
  bool newsletterCB = false;
  bool conditionsCB = false;
  late final WebViewController conditionsWebViewController;
  /* input Controllers */
  final TextEditingController loginController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmationEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmationPasswordController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController compAdresseController = TextEditingController();
  final TextEditingController postalController = TextEditingController();
  final TextEditingController villeController = TextEditingController();
  int? selectedPays;
  int? selectedCivilite;
  int? selectedMetier;
  int? selectedDomaineExpertise;
  int? selectedFormation;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['doc', 'docx', 'pdf', 'rtf'],
    );

    if (result != null) {
      setState(() {
        _pickedFile = File(result.files.single.path!);
      });
    }
  }

  void _register() async {
    final viewModel = Provider.of<SignupViewModel>(context, listen: false);

    if (loginController.text.isEmpty ||
        emailController.text.isEmpty ||
        confirmationEmailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmationPasswordController.text.isEmpty ||
        prenomController.text.isEmpty ||
        nomController.text.isEmpty ||
        adresseController.text.isEmpty ||
        telephoneController.text.isEmpty ||
        postalController.text.isEmpty ||
        villeController.text.isEmpty ||
        selectedPays == null ||
        selectedCivilite == null ||
        selectedMetier == null ||
        selectedDomaineExpertise == null ||
        selectedFormation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }

    if (emailController.text != confirmationEmailController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Les e-mails ne correspondent pas.')),
      );
      return;
    }

    if (passwordController.text != confirmationPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Les mots de passe ne correspondent pas.')),
      );
      return;
    }

    Map<String, dynamic> data = {
      'login': loginController.text,
      'email': emailController.text,
      'passCrypt': passwordController.text,
      'nom': nomController.text,
      'prenom': prenomController.text,
      'adresse1': adresseController.text,
      'complement_adresse': compAdresseController.text,
      'code_postal': postalController.text,
      'ville': villeController.text,
      'pays': selectedPays,
      'user_civilite_id_user_civilite': selectedCivilite,
      'telephone': telephoneController.text,
      'idDomaineSecteur': selectedDomaineExpertise,
      'idFormation': selectedFormation,
      'idMetier': selectedMetier,
      'idEtablissement': null,
      'newsletter': newsletterCB ? 1 : 0,
    };

    bool success = await viewModel.registerStep1(data, _pickedFile);
    if (success && conditionsCB) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondSignupScreen()),
      );
    } else if (!conditionsCB) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez lire et accepter les conditions générales.')),
      );
    } else if (viewModel.errorSignup != null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.errorSignup!)),
      );
    }else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de l\'inscription. Veuillez réessayer.')),
      );
    }
  }

  @override
  void initState() {
    final dataFetchingViewModel = Provider.of<DataFetchingViewModel>(context, listen: false);
    dataFetchingViewModel.fetchListePays();
    dataFetchingViewModel.fetchMetiersBySecteur(55);
    dataFetchingViewModel.fetchSecteurActivites();

    selectedCivilite = 1;
    selectedPays = 1;
    selectedFormation = 23;
    selectedDomaineExpertise = 55;

    selectedMetier = 803;
    conditionsWebViewController = WebViewController()
      ..loadRequest(Uri.parse('https://www.directemploi.com/page/mentions-legales'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: headerBackground,
        elevation: 0,
        centerTitle: true,

        title: Text(
          "Etape 1: Créer mon compte",
          style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold'),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Consumer2<DataFetchingViewModel,SignupViewModel>(
          builder: (context, dataFetchingViewModel,viewModel, child) {
            if (dataFetchingViewModel.isLoadingPays || dataFetchingViewModel.isLoadingSecteur ){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Votre identifiant et mot de passe", style: TextStyle(fontSize: 16, fontFamily: 'semi-bold')),
                Divider(),
                const SizedBox(height: 20),
                DETextField(controller: loginController, prefixIcon: Icons.person, labelText: "Login"),
                const SizedBox(height: 20),
                DETextField(controller: emailController, prefixIcon: Icons.email, labelText: "Email"),
                const SizedBox(height: 20),
                DETextField(controller: confirmationEmailController, prefixIcon: Icons.email, labelText: "Confirmation Email"),
                const SizedBox(height: 20),
                DETextField(
                  controller: passwordController,
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off_outlined),
                    onPressed: _togglePasswordVisibility,
                  ),
                  obscureText: _isPasswordVisible,
                  prefixIcon: Icons.lock,
                  labelText: "Mot de passe",
                ),
                const SizedBox(height: 20),
                DETextField(
                  controller: confirmationPasswordController,
                  suffixIcon: IconButton(
                    icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off_outlined),
                    onPressed: _toggleConfirmPasswordVisibility,
                  ),
                  obscureText: _isConfirmPasswordVisible,
                  prefixIcon: Icons.lock,
                  labelText: "Confirmation Mot de passe",
                ),
                const SizedBox(height: 30),
                Text("Votre état civil", style: TextStyle(fontSize: 16, fontFamily: 'semi-bold')),
                Divider(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: DETextField(controller: prenomController, labelText: "Prénom")),
                    SizedBox(width: 10),
                    Expanded(child: DETextField(controller: nomController, labelText: "Nom")),
                  ],
                ),
                const SizedBox(height: 20),
                DEDropdownMap(
                  labelText: "Sélectionner votre pays",
                  items: dataFetchingViewModel.listePays,
                  onChanged: (value) {
                    setState(() {
                      selectedPays = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                DEDropdownMap(
                  labelText: 'Civilité',
                  items: genderOption,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedCivilite = value;
                      });
                    }
                  },
                ),
                SizedBox(height: 20),
                DETextField(controller: adresseController, labelText: 'Adresse'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: DETextField(controller: telephoneController, labelText: 'Téléphone Portable')),
                    SizedBox(width: 10),
                    Expanded(child: DETextField(controller: compAdresseController, labelText: "Complément d'adresse")),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: DETextField(controller: postalController, labelText: 'Code postal')),
                    SizedBox(width: 10),
                    Expanded(child: DETextField(controller: villeController, labelText: 'Ville')),
                  ],
                ),
                SizedBox(height: 30,),
                Text("Votre domaine d'activité et votre formation",style: TextStyle(fontSize: 16,fontFamily: 'semi-bold'),),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                DEDropdownMap(
                  labelText: 'Domaine d\'expertise',
                  items: dataFetchingViewModel.secteurActivites,

                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedDomaineExpertise = value;
                      });
                      dataFetchingViewModel.fetchMetiersBySecteur(value).then((_) {
                        setState(() {
                          selectedMetier = dataFetchingViewModel.metiers.keys.first;
                        });
                      });
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                DEDropdownMap(
                  labelText: 'Métier',
                  forcedSelectedKey: selectedMetier,
                  initialKey: selectedMetier,
                  items: dataFetchingViewModel.metiers.isNotEmpty ? dataFetchingViewModel.metiers : {},
                  onChanged: (value) {
                    setState(() {
                      selectedMetier = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                DEDropdownMap(
                  labelText: 'Niveau de formation',
                  items: formationOption,

                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedFormation = value;
                      });
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: DottedBorder(
                    dashPattern: const <double>[12, 6],
                    borderType: BorderType.RRect,
                    color: appColor,
                    radius: Radius.circular(25),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.file_present_rounded, size: 48, color: paragraphColor),
                            SizedBox(height: 20),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(text: "Déposer gratuitement mon CV", style: TextStyle(fontFamily: 'semi-bold', color: paragraphColor)),
                                  TextSpan(text: " pour être contacté par plus de 5000 recruteurs", style: TextStyle(fontFamily: 'regular', color: paragraphColor)),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25.0),
                              child: ElevatedButton(
                                style: appButton(),
                                onPressed: _pickFile,
                                child: Text(_pickedFile == null ? 'Importer votre CV' : 'Changer CV'),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text("Taille max. de 1 Mo. Formats acceptés : doc, docx, pdf, rtf.", textAlign: TextAlign.center, style: TextStyle(color: paragraphColor, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                              "M’abonner gratuitement à la newsletter de Direct Emploi et son réseau de sites spécialisés :",
                              style: TextStyle(fontSize: 14, fontFamily: "medium"),
                            ),
                          ),
                          Checkbox(
                            activeColor: appColor,
                            value: newsletterCB,
                            onChanged: (bool? value) {
                              setState(() {
                                newsletterCB = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Préparation à l’entretien d’embauche, CV, conseils de négociation de salaire, fiches métiers, offres d’emploi ciblées, informations sur les formations, offres partenaires",
                        style: TextStyle(fontSize: 13, color: paragraphColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border:Border.all(      color: strokeColor, // Border color
                        width: 1.0,
                      )
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: RichText(
                              text: TextSpan( children:[
                                TextSpan(text:"J'accepte les ",
                                  style: TextStyle(fontSize: 14,fontFamily: "medium",color: textColor),
                                ),
                                TextSpan(text:"conditions générales // rajouter les mentions légales",
                                  style: TextStyle(fontSize: 14,fontFamily: "medium",color: appColor),
                                  recognizer: TapGestureRecognizer()..onTap = () =>
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => WebPageView(controller: conditionsWebViewController,webPageTitle: "Direct Emploi - Mentions légales",))),
                                  //showBottomSheetWebView(context,WebPageView(controller: conditionsWebViewController)),
                                ),
                              ]

                              ),
                            ),
                          ),
                          Checkbox(activeColor:appColor,value: conditionsCB, onChanged: (bool? value) { setState(() {
                            conditionsCB = value!;
                          }); },
                            // Callback function to update the state when the checkbox is tapped
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Text("- Coordonnées transmises aux recruteurs, lecture du CV à des fins de recrutement",
                        style: TextStyle(fontSize: 13,color: paragraphColor),),
                      Text("- Envois potentiels d’offres d’emploi, stage, alternance, formations et communications partenaires",
                        style: TextStyle(fontSize: 13,color: paragraphColor),),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: appButton(),
                  onPressed:viewModel.isLoading ? null : _register,
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
