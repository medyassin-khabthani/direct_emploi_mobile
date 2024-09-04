import 'dart:async';
import 'dart:io';
import 'package:direct_emploi/helper/de_drop_down.dart';
import 'package:direct_emploi/helper/de_text_field.dart';
import 'package:direct_emploi/helper/webpage_view.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:file_picker/file_picker.dart';

import '../datas/de_datas.dart';
import '../helper/de_dropdown_map.dart';
import '../helper/style.dart';
import '../utils/functions.dart';
import '../viewmodels/data_fetching_view_model.dart';
import '../viewmodels/profile_view_model.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int currentPage = 0 ;
  late String _selectedValue;
  ScrollController _scrollController = ScrollController();
  static const List<String> list = <String>['One', 'Two', 'Three', 'Four'];
  static const List<String> switchList = <String>['oui','non'];

  String dropdownValue = list.first;

  File? _pickedFile; // New variable to store the File object
  String? _storedFile; // Existing variable
  String? _fileName1;
  bool _isPasswordVisible = false;
  bool _isConfrimPasswordVisible = false;
  bool newsLetterCB = false;
  int? newsLetterCBInt = 0 ;
  bool conditionsCB = false;

/* input Controllers*/
  final TextEditingController loginController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmationEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmationPasswordController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController civiliteController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController compAdresseController = TextEditingController();
  final TextEditingController postalController = TextEditingController();
  final TextEditingController villeController = TextEditingController();
  final TextEditingController competenceController = TextEditingController();
  final TextEditingController alerteController = TextEditingController();
  int? selectedPays;
  int? selectedCivilite;
  int? selectedMetier;
  int? selectedDomaineExpertise;
  int? selectedFormation;
  int? selectedFourchetteRemuneration;
  int? selectedSituationActivite;
  int? selectedSituationExperience;
  int? selectedDisponibilite;
  int? selectedMobilite;
  int? selectedLangue1;
  int? selectedNiveauLangue1;
  int? selectedLangue2;
  int? selectedNiveauLangue2;
  int permisB = 1;
  int? selectedContratSouhaite;
  int? selectedFourchetteRemunerationSouhaite;
  int isProfileVisible = 1;
  int isProfileAnonyme = 1;
  int isCvVisible = 1;
  int? selectedContratAlert;
  int? selectedExperienceAlert;
  int? selectedDomaineAlert;
  int? selectedRegionAlert;
  int? selectedMetierAlert;
  int? selectedDepartementAlert;

  /* End input Controllers*/

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }
  void _toggleConfrimPasswordVisibility() {
    setState(() {
      _isConfrimPasswordVisible = !_isConfrimPasswordVisible;
    });
  }

  late PageController pageController;
  late final WebViewController conditionsWebViewController;


  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _defaultFileNameController = TextEditingController();
  final _dialogTitleController = TextEditingController();
  final _initialDirectoryController = TextEditingController();
  final _fileExtensionController = TextEditingController();
  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _lockParentWindow = false;
  bool _userAborted = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;

  @override
  void initState(){
      final dataFetchingViewModel = Provider.of<DataFetchingViewModel>(context, listen: false);
      dataFetchingViewModel.fetchListePays();
      dataFetchingViewModel.fetchSecteurActivites();
      dataFetchingViewModel.fetchFourchetteRemuneration();
      dataFetchingViewModel.fetchSituationActivites();
      dataFetchingViewModel.fetchSituationExperiences();
      dataFetchingViewModel.fetchMobilite();
      dataFetchingViewModel.fetchDisponibilite();
      dataFetchingViewModel.fetchLangues();
      dataFetchingViewModel.fetchNiveauxLangue();
      dataFetchingViewModel.fetchMetiersBySecteur(55);
      dataFetchingViewModel.fetchMetiersBySecteurAlert(55);
      dataFetchingViewModel.fetchDepartementsByRegion(12);

      selectedMetier = 803;
      selectedMetierAlert = 803;



    pageController = PageController(initialPage: currentPage);

    conditionsWebViewController = WebViewController()
      ..loadRequest(Uri.parse('https://www.directemploi.com/page/mentions-legales'));
    super.initState();
  }
  @override
  void dispose(){
    pageController.dispose();
    super.dispose();
  }

  void nextPage() {
    /*
    if (currentPage < 2){
      if (_formKeyWork.currentState!.validate()){
        setState(() {
          currentPage++;
        });
      }
      if (_formKeyLocation.currentState!.validate()){
        setState(() {
          currentPage++;
        });
      }
    }*/
    currentPage++;
  }
  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
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
  void _pickFile() async {
    _resetState();
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        compressionQuality: 30,
        type: FileType.custom,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['doc', 'docx', 'pdf', 'rtf'],
        dialogTitle: _dialogTitleController.text,
        initialDirectory: _initialDirectoryController.text,
        lockParentWindow: _lockParentWindow,
      ))
          ?.files;

      // If a file is picked, store the File object and contents
      if (_paths != null && _paths!.isNotEmpty) {
        final file = _paths!.first;
        _pickedFile = File(file.path!); // Create a File object from the path
        _fileName1 = file.name!;
      }

    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName =
      _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: _buildBody(),
      )),
    );
  }
  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      backgroundColor: headerBackground,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: true,
      title: Text(
        "M'inscrire",
        style: TextStyle(fontSize: 14, color: textColor,fontFamily: 'semi-bold'),
      ),
      actions: [
        currentPage >1 ?
      TextButton(onPressed: (){}, child: Text("Passer",style: TextStyle(color: paragraphColor),)):
          SizedBox(width: 0,)
      ],

    );
  }
  Widget _buildBody() {
    return SingleChildScrollView(
      controller:_scrollController,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Flexible(

            child: ConstrainedBox(

              constraints: currentPage == 2 ? BoxConstraints(

                maxHeight: 630,
              ): currentPage == 0 ? BoxConstraints(

                maxHeight: 1850,
              ):currentPage == 1 ? BoxConstraints(

                maxHeight: 1350,
              ):BoxConstraints(

              maxHeight: 1527),
              child: Consumer<DataFetchingViewModel>(
                builder: (context, dataFetchingViewModel, child) {
                return PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: pageController,
                  onPageChanged: (int index){
                    setState(() {
                      _scrollController.jumpTo(0);

                      currentPage = index;
                    });
                  },
                  children: [
                    Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Votre identifiant et mot de passe",style: TextStyle(fontSize: 16,fontFamily: 'semi-bold'),),
                        Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                        DETextField(controller: loginController,prefixIcon:Icons.person , labelText: "Login"),
                        const SizedBox(
                          height: 20,
                        ),
                        DETextField(controller: emailController,prefixIcon:Icons.email , labelText: "Email"),
                        const SizedBox(
                          height: 20,
                        ),
                        DETextField(controller: confirmationEmailController,prefixIcon:Icons.email , labelText: "Confirmation Email"),
                        const SizedBox(
                          height: 20,
                        ),
                        DETextField(controller: passwordController,suffixIcon:IconButton(
                          icon: Icon(_isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off_outlined),
                          onPressed: _togglePasswordVisibility,
                        ),obscureText: _isPasswordVisible,prefixIcon:Icons.lock , labelText: "Mot de passe"),
                        const SizedBox(
                          height: 20,
                        ),
                        DETextField(controller: confirmationPasswordController,suffixIcon:IconButton(
                          icon: Icon(_isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off_outlined),
                          onPressed: _togglePasswordVisibility,
                        ),obscureText: _isConfrimPasswordVisible,prefixIcon:Icons.lock , labelText: "Confirmation Mot de passe"),

                        const SizedBox(
                          height: 30,
                        ),
                        Text("Votre état civil",style: TextStyle(fontSize: 16,fontFamily: 'semi-bold'),),
                        Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: DETextField(controller: prenomController,labelText: "Prénom",),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: DETextField(controller: nomController,labelText: "Nom",),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DEDropdownMap(
                          labelText: "Sélectionner votre pays",
                          items: dataFetchingViewModel.listePays,
                          onChanged: (value) {
                            setState(() {
                              selectedPays = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
                        SizedBox(height:20,),
                        DETextField(controller: adresseController,labelText: 'Adresse',),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: DETextField(controller: telephoneController,labelText: 'Téléphone Portable',),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: DETextField(controller: compAdresseController,labelText: "Complément d'adresse",),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: DETextField(controller: postalController,labelText: 'Code postal',),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: DETextField(controller: villeController,labelText: 'Ville',),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text("Votre état civil",style: TextStyle(fontSize: 16,fontFamily: 'semi-bold'),),
                        const Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                        DEDropdownMap(
                          labelText: 'Domaine d\'activité de l\'entreprise',
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
                        const SizedBox(
                          height: 20,
                        ),
                        Container(

                          width: double.infinity,
                          child: DottedBorder(
                            dashPattern:const <double>[12, 6],
                            borderType: BorderType.RRect,
                            color: appColor,
                            radius: Radius.circular(25),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Center(
                                child: Column(

                                  children: [
                                    Icon(Icons.file_present_rounded,size: 48,color: paragraphColor,),
                                    SizedBox(height: 20,),
                                    RichText(
                                        textAlign: TextAlign.center,
                                        text:
                                    TextSpan(children:[
                                      TextSpan(text:"Déposer gratuitement mon CV",style: TextStyle(fontFamily: 'semi-bold',color: paragraphColor)),
                                      TextSpan(text:" pour être contacté par plus de 5000 recruteurs",style: TextStyle(fontFamily: 'regular',color: paragraphColor)),

                                    ])),
                                    SizedBox(height: 20,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                      child: ElevatedButton(
                                        onPressed: () => _pickFile(),
                                        child: _fileName1 != null ? const Text(

                                          'Changer votre cv',
                                          style: TextStyle(fontFamily: 'medium', fontSize: 14),
                                        ):
                                        const Text(
                                          'Importer votre cv',
                                          style: TextStyle(fontFamily: 'medium', fontSize: 14),
                                        ),
                                        style: appButton(),
                                      ),
                                    ),
                                    _fileName1 != null ? Column(
                                      children: [
                                        SizedBox(height: 20,),
                                        Text(_fileName1!,style: TextStyle(fontFamily: "semi-bold"),),
                                      ],
                                    ):SizedBox(height:0),
                                    SizedBox(height: 20,),

                                    Text("Taille max. de 1 Mo. Formats acceptés : doc, docx, pdf, rtf.",textAlign: TextAlign.center,style: TextStyle(color: paragraphColor,fontSize: 12),)
                                  ],
                                ),
                              ),
                            ),

                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
                                    child: Text("M’abonner gratuitement à la newsletter de Direct Emploi et son réseau de sites spécialisés :",
                                      style: TextStyle(fontSize: 14,fontFamily: "medium"),
                                    ),
                                  ),
                              Checkbox(activeColor:appColor,value: newsLetterCB, onChanged: (bool? value) { setState(() {
                                newsLetterCB = value!;
                                if (value == false){
                                  newsLetterCBInt = 0;
                                } else{
                                  newsLetterCBInt = 1;
                                }
                                print(newsLetterCBInt);

                              }); },
                                 // Callback function to update the state when the checkbox is tapped
                              ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Text("Préparation à l’entretien d’embauche, CV, conseils de négociation de salaire, fiches métiers, offres d’emploi ciblées, informations sur les formations, offres partenaires",
                              style: TextStyle(fontSize: 13,color: paragraphColor),)
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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

                      ],
                    ),
                  ),
                    Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Votre Situation actuelle",style: TextStyle(fontSize: 16,fontFamily: 'semi-bold'),),
                          const SizedBox(
                            height: 20,
                          ),
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
                          const SizedBox(
                            height: 30,
                          ),
                          Text("Vos compétences",style: TextStyle(fontSize: 16,fontFamily: 'semi-bold'),),
                          const SizedBox(
                            height: 20,
                          ),
                          DETextField(controller: competenceController, labelText: "Liste des compétences"),
                          const SizedBox(
                            height: 20,
                          ),
                          DEDropdownMap(
                            labelText: 'Langue étrangère 1',
                            items: dataFetchingViewModel.langues,
                            onChanged: (value) {
                              setState(() {
                                selectedLangue1 = value;
                              });
                            },
                          ),
                          SizedBox(height: 20,),
                          DEDropdownMap(
                            labelText: 'Niveau',
                            items: dataFetchingViewModel.niveaux,
                            onChanged: (value) {
                              setState(() {
                                selectedNiveauLangue1 = value;
                              });
                            },
                          ),


                          const SizedBox(
                            height: 20,
                          ),
                          DEDropdownMap(
                            labelText: 'Langue étrangère 2',
                            items: dataFetchingViewModel.langues,
                            onChanged: (value) {
                              setState(() {
                                selectedLangue2 = value;
                              });
                            },
                          ),
                          SizedBox(height: 20,),
                          DEDropdownMap(
                            labelText: 'Niveau',
                            items: dataFetchingViewModel.niveaux,
                            onChanged: (value) {
                              setState(() {
                                selectedNiveauLangue2 = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Permis B",style: TextStyle(fontFamily: 'medium'),),
                              SizedBox(width: 10,),
                              ToggleSwitch(

                                minWidth: 60.0,
                                minHeight: 35.0,
                                fontSize: 14.0,
                                initialLabelIndex: 0,
                                activeBgColor: [appColor],
                                activeFgColor: Colors.white,
                                inactiveBgColor: headerBackground,
                                inactiveFgColor: appColor,
                                totalSwitches: 2,
                                labels: switchList,
                                onToggle: (index) {
                                  if (index == 1){
                                    permisB = 0;
                                  }else{
                                    permisB = 1;
                                  }

                                  print(index);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text("Votre recherche d'emploi",style: TextStyle(fontSize: 16,fontFamily: 'semi-bold'),),
                          const SizedBox(
                            height: 20,
                          ),

                          DEDropdownMap(
                            labelText: 'Type de contrat souhaité',
                            items: contratOptionsInt,
                            onChanged: (value) {
                              setState(() {
                                selectedContratSouhaite = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          DEDropdownMap(
                            labelText: 'Salaire souhaité',
                            items: dataFetchingViewModel.fourchettes,
                            onChanged: (value) {
                              setState(() {
                                selectedFourchetteRemunerationSouhaite = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text("Paramètres de confidentialité",style: TextStyle(fontSize: 16,fontFamily: 'semi-bold'),),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: Text("Rendre mon profil visible (votre profil sera consultable par les recruteurs)",style: TextStyle(fontFamily: 'medium'),)),
                              SizedBox(width: 10,),
                              ToggleSwitch(
                                minWidth: 60.0,
                                minHeight: 35.0,
                                fontSize: 14.0,
                                initialLabelIndex: 0,
                                activeBgColor: [appColor],
                                activeFgColor: Colors.white,
                                inactiveBgColor: headerBackground,
                                inactiveFgColor: appColor,
                                totalSwitches: 2,
                                labels: ['Oui', 'Non',],
                                onToggle: (index) {
                                  if (index == 1){
                                    isProfileVisible = 0;
                                  }else{
                                    isProfileVisible = 1;
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: Text("Rendre mon profil anonyme (vos informations civiles seront masquées, veilliez à utiliser un CV anonyme)",style: TextStyle(fontFamily: 'medium'),)),
                              SizedBox(width: 10,),
                              ToggleSwitch(
                                minWidth: 60.0,
                                minHeight: 35.0,
                                fontSize: 14.0,
                                initialLabelIndex: 0,
                                activeBgColor: [appColor],
                                activeFgColor: Colors.white,
                                inactiveBgColor: headerBackground,
                                inactiveFgColor: appColor,
                                totalSwitches: 2,
                                labels: ['Oui', 'Non',],
                                onToggle: (index) {
                                  if (index == 1){
                                    isProfileAnonyme = 0;
                                  }else{
                                    isProfileAnonyme = 1;
                                  }
                                  print('switched to: $index');
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: Text("Rendre mon CV visible (les recruteurs pourront télécharger votre CV)",style: TextStyle(fontFamily: 'medium'),)),
                              SizedBox(width: 10,),
                              ToggleSwitch(
                                minWidth: 60.0,
                                minHeight: 35.0,
                                fontSize: 14.0,
                                initialLabelIndex: 0,
                                activeBgColor: [appColor],
                                activeFgColor: Colors.white,
                                inactiveBgColor: headerBackground,
                                inactiveFgColor: appColor,
                                totalSwitches: 2,
                                labels: ['Oui', 'Non',],
                                onToggle: (index) {
                                  if (index == 1){
                                    isCvVisible = 0;
                                  }else{
                                    isCvVisible = 1;
                                  }
                                  print('switched to: $index');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Création / Édition d'une alerte mail",style: TextStyle(fontSize: 16,fontFamily: 'semi-bold'),),
                          const SizedBox(
                            height: 20,
                          ),
                          DETextField(controller: alerteController, labelText: "Nom de mon alerte"),
                          const SizedBox(
                            height: 20,
                          ),
                          DEDropdownMap(
                            labelText: 'Type de contrat souhaité',
                            items: contratOptionsInt,
                            onChanged: (value) {
                              setState(() {
                                selectedContratSouhaite = value;
                              });
                            },
                          ),
                          SizedBox(height: 20,),
                          DEDropdownMap(
                            labelText: 'Experience',
                            items: dataFetchingViewModel.situationExperiences,
                            onChanged: (value) {
                              setState(() {
                                selectedExperienceAlert = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
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
                          const SizedBox(
                            height: 20,
                          ),
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
                          const SizedBox(
                            height: 20,
                          ),
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
                          const SizedBox(
                            height: 20,
                          ),
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
                          const SizedBox(
                            height: 20,
                          ),
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
                                      child: Text("N'afficher que les offres ouvertes aux personnes en situation de handicap",
                                        style: TextStyle(fontSize: 14,fontFamily: "medium"),
                                      ),
                                    ),
                                    Checkbox(activeColor:appColor,value: true, onChanged: (bool? value) { print("checkbox changed"); },
                                      // Callback function to update the state when the checkbox is tapped
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    )],
                );
                },
              ),
            ),
          ),
          SizedBox(height: 20,),
          Center(
            child: DotsIndicator(
              dotsCount: 3,
              position: currentPage,
              decorator: DotsDecorator(
                size: const Size.square(8.0),
                activeSize: const Size(28.0, 8.0),
                activeColor: appColor,
                color: const Color(0xFFE4E5E7),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
          ),
          SizedBox(height: 20,),

          ElevatedButton(
            onPressed: () {
              pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);

            },
            child:  Text(
             currentPage == 2  ? 'Enregistrer' : 'Valider et continuer',
              style: TextStyle(fontFamily: 'medium', fontSize: 14),
            ),
            style: appButton(),
          ),
          currentPage >0 ? TextButton(onPressed: (){
            print(_pickedFile);
            setState(() {
              pageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);
              //currentPage--;
            });
          }, child: Text("Retour",style: TextStyle(color:paragraphColor),)):SizedBox(height:0),
        ],
      ),
    );
  }

}
