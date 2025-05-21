import 'dart:io';

import 'package:direct_emploi/helper/de_dropdown_map.dart';
import 'package:direct_emploi/helper/de_text_field.dart';
import 'package:direct_emploi/helper/style.dart';
import 'package:direct_emploi/helper/webpage_view.dart';
import 'package:direct_emploi/models/offre_model.dart';
import 'package:direct_emploi/pages/similar_offer_screen.dart';
import 'package:direct_emploi/services/user_manager.dart';
import 'package:direct_emploi/viewmodels/data_fetching_view_model.dart';
import 'package:direct_emploi/viewmodels/offre_view_model.dart';
import 'package:direct_emploi/viewmodels/profile_view_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OfferSubmissionScreen extends StatefulWidget {
  final Offre offre;
  const OfferSubmissionScreen({Key? key, required this.offre}) : super(key: key);

  @override
  State<OfferSubmissionScreen> createState() => _OfferSubmissionScreenState();
}

class _OfferSubmissionScreenState extends State<OfferSubmissionScreen> {
  // ---------------------------------------------------------------------------
  // Text Controllers
  // ---------------------------------------------------------------------------
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController postalController = TextEditingController();
  final TextEditingController localisationController = TextEditingController();
  final TextEditingController diplomeController = TextEditingController();

  // This boolean ensures we only set text fields once
  bool _fieldsInitialized = false;

  // ---------------------------------------------------------------------------
  // File & CV handling
  // ---------------------------------------------------------------------------
  String? _fileName1; // CV name
  File? _pickedFileCv;
  String? _fileName2; // LM name
  File? _pickedFileLm;
  String? _storedFile; // Unused if referencing user CV
  int? selectedCvId;  // If picking existing CV from userCvs
  bool isCvLocal = false;

  // ---------------------------------------------------------------------------
  // Additional state
  // ---------------------------------------------------------------------------
  late final WebViewController conditionsWebViewController;
  bool conditionsCB = false; // Terms & conditions

  // Domain selection
  int? selectedSecteur;   // "Domaine d’expertise"
  int? selectedMetier;    // After picking a secteur, we load metiers

  // Validation for phone and postal code
  bool _validateFrenchPhoneNumber(String? value) {
    return value == null || !RegExp(r'^(\+33[0-9]{9}|0[0-9]{9})$').hasMatch(value);
    // true => invalid
  }

  bool _validatePostalCode(String? value) {
    return value == null || !RegExp(r'^\d{5}$').hasMatch(value);
    // true => invalid
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    final dataVM = Provider.of<DataFetchingViewModel>(context, listen: false);
    final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
    final userId = UserManager.instance.userId!;

    // Fetch data
    dataVM.fetchSecteurActivites();
    profileVM.fetchPersonalInfo(userId);
    profileVM.fetchUserCvs(userId);

    // Mentions légales
    conditionsWebViewController = WebViewController()
      ..loadRequest(Uri.parse('https://www.directemploi.com/page/mentions-legales'));
  }

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    emailController.dispose();
    telController.dispose();
    postalController.dispose();
    localisationController.dispose();
    diplomeController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Consumer2<ProfileViewModel, DataFetchingViewModel>(
            builder: (context, profileVM, dataVM, child) {
              // 1) Check if profile is still loading or if personalInfo is null
              if (profileVM.isLoadingPersonal || dataVM.isLoadingSecteur) {
                return const Center(child: CircularProgressIndicator());
              }
              if (profileVM.error != null || dataVM.error != null) {
                return const Center(child: Text('Failed to load data'));
              }

              final personalInfo = profileVM.personalInfo;
              if (personalInfo == null) {
                // If personalInfo is still null, show spinner
                return const Center(child: CircularProgressIndicator());
              }

              // 2) Initialize fields only once
              if (!_fieldsInitialized) {
                _fieldsInitialized = true;
                nomController.text = personalInfo.nom ?? '';
                prenomController.text = personalInfo.prenom ?? '';
                emailController.text = personalInfo.email ?? '';
                telController.text = personalInfo.telephone ?? '';
                postalController.text = personalInfo.geoAdresse?.codePostal ?? '';
                // For others like localisation if needed
              }

              return _buildBody(context, profileVM, dataVM);
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
      title: const Text(
        'Formulaire de réponse à l\'offre',
        style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold'),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      ProfileViewModel profileVM,
      DataFetchingViewModel dataVM,
      ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Informations Personnelles",
            style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold'),
          ),
          const Divider(),
          const SizedBox(height: 20),
          DETextField(controller: nomController, labelText: 'Nom'),
          const SizedBox(height: 20),
          DETextField(controller: prenomController, labelText: 'Prénom'),
          const SizedBox(height: 20),
          DETextField(controller: emailController, labelText: 'Email'),
          const SizedBox(height: 20),
          DETextField(controller: telController, labelText: 'Téléphone (Optionnel)'),
          const SizedBox(height: 20),
          DETextField(controller: postalController, labelText: 'Code postal'),
          const SizedBox(height: 40),

          // Domaine d'activité
          const Text(
            "Domaine d'activité",
            style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold'),
          ),
          const Divider(),
          const SizedBox(height: 20),
          // "Domaine d'expertise" - Bind to selectedSecteur
          DEDropdownMap(
            labelText: 'Domaine d\'expertise',
            items: dataVM.secteurActivites,
            initialKey: selectedSecteur,
            onChanged: (value) {
              if (value != null) {
                setState(() => selectedSecteur = value);
                dataVM.fetchMetiersBySecteur(value).then((_) {
                  setState(() {
                    selectedMetier = dataVM.metiers.keys.isNotEmpty
                        ? dataVM.metiers.keys.first
                        : null;
                  });
                });
              }
            },
          ),

          const SizedBox(height: 40),
          // Fichiers
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Fichiers",
                style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold'),
              ),
              Text(
                "Taille max. de 1 Mo. Formats acceptés : doc, docx, pdf, rtf.",
                textAlign: TextAlign.center,
                style: TextStyle(color: paragraphColor, fontSize: 12),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 20),
          _buildCvPicker(context, profileVM),
          const SizedBox(height: 20),
          _buildLmPicker(context),
          const SizedBox(height: 30),

          _buildConditions(context),

          const SizedBox(height: 20),
          Consumer<OffreViewModel>(
            builder: (context, offreVM, child) {
              return ElevatedButton(
                style: appButton(),
                onPressed: offreVM.isLoading ? null : () => _submitApplication(offreVM),
                child: offreVM.isLoading
                    ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : const Text("Soumettre"),
              );
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CV & LM pickers
  // ---------------------------------------------------------------------------
  Widget _buildCvPicker(BuildContext context, ProfileViewModel profileVM) {
    return Center(
      child: Column(
        children: [
          OutlinedButton(
            onPressed: () => _pickFileCv(context, profileVM),
            style: outlinedAppButton(),
            child: _fileName1 != null
                ? const Text(
              'Changer votre cv',
              style: TextStyle(fontFamily: 'medium', fontSize: 14),
            )
                : const Text(
              'Importer votre cv',
              style: TextStyle(fontFamily: 'medium', fontSize: 14),
            ),
          ),
          if (_fileName1 != null) ...[
            const SizedBox(height: 20),
            Text(_fileName1!, style: const TextStyle(fontFamily: "semi-bold")),
          ],
        ],
      ),
    );
  }

  Widget _buildLmPicker(BuildContext context) {
    return Center(
      child: Column(
        children: [
          OutlinedButton(
            onPressed: _pickFileLm,
            style: outlinedAppButton(),
            child: _fileName2 != null
                ? const Text(
              'Changer votre lettre de motivation',
              style: TextStyle(fontFamily: 'medium', fontSize: 14),
            )
                : const Text(
              'Importer votre lettre de motivation',
              style: TextStyle(fontFamily: 'medium', fontSize: 14),
            ),
          ),
          if (_fileName2 != null) ...[
            const SizedBox(height: 20),
            Text(_fileName2!, style: const TextStyle(fontFamily: "semi-bold")),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Terms & conditions
  // ---------------------------------------------------------------------------
  Widget _buildConditions(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: strokeColor, width: 1.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "J'accepte les ",
                        style: TextStyle(fontSize: 14, fontFamily: "medium", color: textColor),
                      ),
                      TextSpan(
                        text: "conditions générales ",
                        style: const TextStyle(fontSize: 14, fontFamily: "medium", color: appColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebPageView(
                                controller: conditionsWebViewController,
                                webPageTitle: "Direct Emploi - Mentions légales",
                              ),
                            ),
                          ),
                      ),
                      const TextSpan(
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
                  setState(() => conditionsCB = value ?? false);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "- Coordonnées transmises aux recruteurs, lecture du CV à des fins de recrutement",
            style: TextStyle(fontSize: 13, color: paragraphColor),
          ),
          const Text(
            "- Envois potentiels d’offres d’emploi, stage, alternance, formations et communications partenaires",
            style: TextStyle(fontSize: 13, color: paragraphColor),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Submit Application
  // ---------------------------------------------------------------------------
  Future<void> _submitApplication(OffreViewModel offreViewModel) async {
    if (!conditionsCB) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vous devez accepter les termes et les conditions")),
      );
      return;
    }

    // Validate phone (optionnel, only if user filled it?)
    if (telController.text.isNotEmpty && _validateFrenchPhoneNumber(telController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Numéro invalide (format: +33X ou 0X)")),
      );
      return;
    }

    // Validate postal code
    if (_validatePostalCode(postalController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Le code postal doit contenir 5 chiffres.")),
      );
      return;
    }
    // Validate postal code
    if ( !isCvLocal && _pickedFileCv == null ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez ajouter votre cv.")),
      );
      return;
    }

    try {
      await offreViewModel.applyForOffer(
        userId: UserManager.instance.userId!,
        offerId: widget.offre.id,
        email: emailController.text,
        prenom: prenomController.text,
        nom: nomController.text,
        cvFile: isCvLocal ? null : _pickedFileCv,
        lmFile: _pickedFileLm,
        cvId: selectedCvId,
        isCvLocal: isCvLocal,
      );

      final cv = offreViewModel.cv;
      final lm = offreViewModel.lm;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SimilarOfferScreen(
            nom: nomController.text,
            prenom: prenomController.text,
            email: emailController.text,
            cv: cv,
            lm: (lm != '') ? lm : null,
            offerId: widget.offre.id,
            userId: UserManager.instance.userId!,
          ),
        ),
      );
    } catch (e) {
      _logException('Failed to submit application: ${e.toString()}');
    }
  }

  // ---------------------------------------------------------------------------
  // CV selection logic
  // ---------------------------------------------------------------------------
  Future<void> _pickFileCv(BuildContext context, ProfileViewModel profileVM) async {
    try {
      final result = await showDialog<FilePickerResult>(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Row(
                      children: const [
                        Icon(Icons.cloud_upload),
                        SizedBox(width: 10),
                        Text("Importer un nouveau CV", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    onTap: () async {
                      final picked = await FilePicker.platform.pickFiles(
                        compressionQuality: 30,
                        type: FileType.custom,
                        allowMultiple: false,
                        allowedExtensions: ['doc', 'docx', 'pdf', 'rtf'],
                      );
                      Navigator.of(context).pop(picked);
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text("Ou choisir depuis le profil", style: TextStyle(fontSize: 15, fontFamily: "semi-bold")),
                  const SizedBox(height: 10),
                  // If userCvs is null or not loaded, handle gracefully
                  if (profileVM.userCvs == null)
                    const Center(child: Text("Aucun CV disponible"))
                  else
                    ...profileVM.userCvs!.map((cv) => ListTile(
                      title: Text(cv.nomFichierCvOriginal),
                      onTap: () {
                        setState(() {
                          _fileName1 = cv.nomFichierCvOriginal;
                          selectedCvId = cv.id;
                          isCvLocal = true;
                          _pickedFileCv = null; // Because we are not uploading a new file
                        });
                        Navigator.of(ctx).pop();
                      },
                    )),
                ],
              ),
            ),
          );
        },
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        setState(() {
          // The user chose a brand new local CV
          _pickedFileCv = File(file.path!);
          _fileName1 = file.name;
          selectedCvId = null; // Because we used a local file, not userCvs
          isCvLocal = false;   // This indicates we are uploading a new local file
        });
      }
    } on PlatformException catch (e) {
      _logException('Unsupported operation: ${e.toString()}');
    } catch (e) {
      _logException(e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // LM selection logic
  // ---------------------------------------------------------------------------
  Future<void> _pickFileLm() async {
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

  // ---------------------------------------------------------------------------
  // Error logging
  // ---------------------------------------------------------------------------
  void _logException(String message) {
    debugPrint(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(color: Colors.white))),
    );
  }
}
