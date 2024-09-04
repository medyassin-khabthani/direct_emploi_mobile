import 'package:direct_emploi/helper/de_text_field.dart';
import 'package:direct_emploi/models/offre_model.dart';
import 'package:direct_emploi/viewmodels/data_fetching_view_model.dart';
import 'package:direct_emploi/viewmodels/profile_view_model.dart';
import 'package:direct_emploi/viewmodels/offre_view_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

import '../helper/de_dropdown_map.dart';
import '../helper/style.dart';
import '../helper/webpage_view.dart';
import '../services/user_manager.dart';
import 'similar_offer_screen.dart';

class OfferSubmissionScreen extends StatefulWidget {
  final Offre offre;
  const OfferSubmissionScreen({super.key, required this.offre});

  @override
  State<OfferSubmissionScreen> createState() => _OfferSubmissionScreenState();
}

class _OfferSubmissionScreenState extends State<OfferSubmissionScreen> {
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController postalController = TextEditingController();
  TextEditingController localisationController = TextEditingController();
  TextEditingController diplomeController = TextEditingController();
  int? selectedMetier;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? _fileName;
  File? _pickedFileCv;
  File? _pickedFileLm;
  String? _storedFile;
  String? _fileName1;
  String? _fileName2;
  late final WebViewController conditionsWebViewController;
  bool conditionsCB = false;
  int? selectedCvId;
  bool isCvLocal = false;

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _fileName = null;
      _pickedFileCv = null;
      _pickedFileLm = null;
      _storedFile = null;
      _fileName1 = null;
      selectedCvId = null;
    });
  }

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _pickFileCv() async {
    try {
      final result = await showDialog<FilePickerResult>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.cloud_upload),
                        SizedBox(width: 10,),
                        Text("Importer un nouveau CV",style: TextStyle(fontSize: 14),),
                      ],
                    ),
                    onTap: () async {
                      final result = await FilePicker.platform.pickFiles(
                        compressionQuality: 30,
                        type: FileType.custom,
                        allowMultiple: false,
                        allowedExtensions: ['doc', 'docx', 'pdf', 'rtf'],
                      );
                      Navigator.of(context).pop(result);
                    },
                  ),
                  SizedBox(height: 10,),
                  Text("Ou choisir depuis le profil", style: TextStyle(fontSize: 15,fontFamily: "semi-bold"),),
                  SizedBox(height: 10,),
                  Consumer<ProfileViewModel>(
                    builder: (context, viewModel, child) {
                      return SingleChildScrollView(
                        child: ListBody(
                          children: viewModel.userCvs!
                              .map((cv) => ListTile(
                              title: Text(cv.nomFichierCvOriginal),
                              onTap: () {
                                setState(() {
                                  _fileName1 = cv.nomFichierCvOriginal;
                                  selectedCvId = cv.id;
                                  isCvLocal = true;
                                });
                                Navigator.of(context).pop();
                              }
                          ))
                              .toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        setState(() {
          _pickedFileCv = File(file.path!);
          _fileName1 = file.name;
        });
      }
    } on PlatformException catch (e) {
      _logException('Unsupported operation: ${e.toString()}');
    } catch (e) {
      _logException(e.toString());
    }
  }

  void _pickFileLm() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        compressionQuality: 30,
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['doc', 'docx', 'pdf', 'rtf'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        setState(() {
          _pickedFileLm = File(file.path!);
          _fileName2 = file.name;
        });
      }
    } on PlatformException catch (e) {
      _logException('Unsupported operation: ${e.toString()}');
    } catch (e) {
      _logException(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    UserManager userManager = UserManager.instance;
    Provider.of<DataFetchingViewModel>(context, listen: false).fetchSecteurActivites();
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    profileViewModel.fetchPersonalInfo(userManager.userId!);
    profileViewModel.fetchUserCvs(userManager.userId!);

    conditionsWebViewController = WebViewController()
      ..loadRequest(Uri.parse('https://www.directemploi.com/page/mentions-legales'));
  }

  void _submitApplication() async {
    final offreViewModel = Provider.of<OffreViewModel>(context, listen: false);
    final userManager = UserManager.instance;
    if (conditionsCB == true){
      try {
        await offreViewModel.applyForOffer(
          userId: userManager.userId!,
          offerId: widget.offre.id,
          email: emailController.text,
          prenom: prenomController.text,
          nom: nomController.text,
          cvFile: isCvLocal ? null : _pickedFileCv,
          lmFile: _fileName2 != null ? _pickedFileLm : null,
          cvId: selectedCvId,
          isCvLocal: isCvLocal,
        );

        final cv = offreViewModel.cv;
        final lm = offreViewModel.lm;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SimilarOfferScreen(nom: nomController.text, prenom: prenomController.text, email: emailController.text, cv: cv, lm: lm != '' ? lm : null, offerId: widget.offre.id, userId: userManager.userId!, )),
        );
      } catch (e) {
        _logException('Failed to submit application: ${e.toString()}');
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vous devez Accepter les termes et les conditions")));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Consumer2<ProfileViewModel, DataFetchingViewModel>(
            builder: (context, profileViewModel, viewModel, child) {
              if (profileViewModel.personalInfo?.nom != null) {
                nomController.text = profileViewModel.personalInfo!.nom!;
              }
              if (profileViewModel.personalInfo?.prenom != null) {
                prenomController.text = profileViewModel.personalInfo!.prenom!;
              }
              if (profileViewModel.personalInfo?.telephone != null) {
                telController.text = profileViewModel.personalInfo!.telephone!;
              }
              if (profileViewModel.personalInfo?.geoAdresse?.codePostal != null) {
                postalController.text = profileViewModel.personalInfo!.geoAdresse!.codePostal!;
              }
              emailController.text = profileViewModel.personalInfo!.email!;

              if (viewModel.isLoadingSecteur) {
                return Center(child: CircularProgressIndicator());
              } else if (viewModel.error != null) {
                return Center(child: Text('Failed to load data'));
              } else {
                return _buildBody(profileViewModel, viewModel);
              }
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text('Formulaire de réponse à l\'offre', style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold')));
  }

  Widget _buildBody(ProfileViewModel profileViewModel, DataFetchingViewModel viewModel) {
    final offreViewModel = Provider.of<OffreViewModel>(context, listen: false);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Informations Personnelles", style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold')),
          Divider(),
          SizedBox(height: 20),
          DETextField(controller: nomController, labelText: 'Nom'),
          SizedBox(height: 20),
          DETextField(controller: prenomController, labelText: 'Prénom'),
          SizedBox(height: 20),
          DETextField(controller: emailController, labelText: 'Email'),
          SizedBox(height: 20),
          DETextField(controller: telController, labelText: 'Téléphone (Optionnel)'),
          SizedBox(height: 20),
          DETextField(controller: postalController, labelText: 'Code postal'),
          SizedBox(height: 40),
          Text("Domaine d'activité", style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold')),
          Divider(),
          SizedBox(height: 20),
          DEDropdownMap(
            labelText: 'Domaine d\'expertise',
            items: viewModel.secteurActivites,
            onChanged: (value) {
              if (value != null) {
                Provider.of<DataFetchingViewModel>(context, listen: false)
                    .fetchMetiersBySecteur(value)
                    .then((_) {
                  setState(() {
                    selectedMetier = viewModel.metiers.keys.first;
                  });
                });
              }
            },
          ),
          SizedBox(height: 40),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Fichiers", style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold')),
              Text("Taille max. de 1 Mo. Formats acceptés : doc, docx, pdf, rtf.", textAlign: TextAlign.center, style: TextStyle(color: paragraphColor, fontSize: 12)),
            ],
          ),
          Divider(),
          SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                OutlinedButton(
                    onPressed: _pickFileCv,
                    child: _fileName1 != null
                        ? const Text(
                      'Changer votre cv',
                      style: TextStyle(fontFamily: 'medium', fontSize: 14),
                    )
                        : const Text(
                      'Importer votre cv',
                      style: TextStyle(fontFamily: 'medium', fontSize: 14),
                    ),
                    style: outlinedAppButton()),
                _fileName1 != null
                    ? Column(
                  children: [
                    SizedBox(height: 20),
                    Text(_fileName1!, style: TextStyle(fontFamily: "semi-bold")),
                  ],
                )
                    : SizedBox(height: 0),
              ],
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                OutlinedButton(
                    onPressed: _pickFileLm,
                    child: _fileName2 != null
                        ? const Text(
                      'Changer votre lettre de motivation',
                      style: TextStyle(fontFamily: 'medium', fontSize: 14),
                    )
                        : const Text(
                      'Importer votre lettre de motivation',
                      style: TextStyle(fontFamily: 'medium', fontSize: 14),
                    ),
                    style: outlinedAppButton()),
                _fileName2 != null
                    ? Column(
                  children: [
                    SizedBox(height: 20),
                    Text(_fileName2!, style: TextStyle(fontFamily: "semi-bold")),
                  ],
                )
                    : SizedBox(height: 0),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: strokeColor, // Border color
                        width: 1.0,
                      )),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "J'accepte les ",
                                    style: TextStyle(fontSize: 14, fontFamily: "medium", color: textColor),
                                  ),
                                  TextSpan(
                                    text: "conditions générales ",
                                    style: TextStyle(fontSize: 14, fontFamily: "medium", color: appColor),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => WebPageView(
                                              controller: conditionsWebViewController,
                                              webPageTitle: "Direct Emploi - Mentions légales",
                                            )),
                                      ),
                                  ),
                                  TextSpan(
                                    text: "de Direct Emploi",
                                    style: TextStyle(fontSize: 14, fontFamily: "medium", color: textColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Checkbox(
                            activeColor: appColor,
                            value: conditionsCB,
                            onChanged: (bool? value) {
                              setState(() {
                                conditionsCB = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "- Coordonnées transmises aux recruteurs, lecture du CV à des fins de recrutement",
                        style: TextStyle(fontSize: 13, color: paragraphColor),
                      ),
                      Text(
                        "- Envois potentiels d’offres d’emploi, stage, alternance, formations et communications partenaires",
                        style: TextStyle(fontSize: 13, color: paragraphColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: appButton(),
            onPressed:offreViewModel.isLoading ? null : _submitApplication,
            child:offreViewModel.isLoading
                ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
                : Text("Soumettre"),
          ),
        ],
      ),
    );
  }
}
