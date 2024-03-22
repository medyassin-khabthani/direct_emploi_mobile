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
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:file_picker/file_picker.dart';

import '../helper/style.dart';
import '../utils/functions.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int currentPage = 0 ;
  late String _selectedValue;

  static const List<String> list = <String>['One', 'Two', 'Three', 'Four'];
  static const List<String> switchList = <String>['oui','non'];

  String dropdownValue = list.first;

  File? _pickedFile; // New variable to store the File object
  String? _storedFile; // Existing variable
  String? _fileName1;
  bool _isPasswordVisible = false;
  bool _isConfrimPasswordVisible = false;
  bool newsLetterCB = false;
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


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Flexible(

            child: ConstrainedBox(

              constraints: currentPage == 2 ? BoxConstraints(

                maxHeight: 580,
              ): currentPage == 0 ? BoxConstraints(

                maxHeight: 1527,
              ):currentPage == 1 ? BoxConstraints(

                maxHeight: 1300,
              ):BoxConstraints(

              maxHeight: 1527),
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: pageController,
                onPageChanged: (int index){
                  setState(() {
                    currentPage = index;
                  });
                },
                children: [
                  Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Votre identifiant et mot de passe",style: TextStyle(fontSize: 16,fontFamily: 'semi-bold'),),
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
                      DEDropdown(labelText: "Selectionnez votre pays",items: list, onChanged: (value) {
                        dropdownValue = value!;
                        print("Selected salary: $dropdownValue");
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: DETextField(controller: civiliteController,labelText: 'Civilité',),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: DETextField(controller: telephoneController,labelText: 'Téléphone Portable',),
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
                            child: DETextField(controller: adresseController,labelText: 'Adresse',),
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
                          DEDropdown(labelText: "Salaire du poste",items: list, onChanged: (value) {
                            dropdownValue = value!;
                            print("Selected salary: $dropdownValue");
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        DEDropdown(labelText: "Activité",items: list, onChanged: (value) {
                          dropdownValue = value!;
                          print("Selected salary: $dropdownValue");
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        DEDropdown(labelText: "Nombre d'années d'expérience",items: list, onChanged: (value) {
                          dropdownValue = value!;
                          print("Selected salary: $dropdownValue");
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        DEDropdown(labelText: "Disponibilité",items: list, onChanged: (value) {
                          dropdownValue = value!;
                          print("Selected salary: $dropdownValue");
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        DEDropdown(labelText: "Mobilité",items: list, onChanged: (value) {
                          dropdownValue = value!;
                          print("Selected salary: $dropdownValue");
                        }),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: DEDropdown(labelText: "Langue étrangère 1",items: list, onChanged: (value) {
                                dropdownValue = value!;
                                print("Selected salary: $dropdownValue");
                              }),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: DEDropdown(labelText: "Niveau",items: list, onChanged: (value) {
                                dropdownValue = value!;
                                print("Selected salary: $dropdownValue");
                              }),
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
                              child: DEDropdown(labelText: "Langue étrangère 2",items: list, onChanged: (value) {
                                dropdownValue = value!;
                                print("Selected salary: $dropdownValue");
                              }),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: DEDropdown(labelText: "Niveau",items: list, onChanged: (value) {
                                dropdownValue = value!;
                                print("Selected salary: $dropdownValue");
                              }),
                            ),
                          ],
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
                                var switchChoice = switchList[index!];
                                print(switchChoice);
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
                        DEDropdown(labelText: "Type de contrat souhaité",items: list, onChanged: (value) {
                          dropdownValue = value!;
                          print("Selected salary: $dropdownValue");
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        DEDropdown(labelText: "Salaire souhaité",items: list, onChanged: (value) {
                          dropdownValue = value!;
                          print("Selected salary: $dropdownValue");
                        }),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: DEDropdown(labelText: "Type de contrat",items: list, onChanged: (value) {
                                dropdownValue = value!;
                                print("Selected salary: $dropdownValue");
                              }),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: DEDropdown(labelText: "Type de contrat",items: list, onChanged: (value) {
                                dropdownValue = value!;
                                print("Selected salary: $dropdownValue");
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DEDropdown(labelText: "Domaine de votre métier",items: list, onChanged: (value) {
                          dropdownValue = value!;
                          print("Selected salary: $dropdownValue");
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        DEDropdown(labelText: "Région",items: list, onChanged: (value) {
                          dropdownValue = value!;
                          print("Selected salary: $dropdownValue");
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        DEDropdown(labelText: "Métier",items: list, onChanged: (value) {
                          dropdownValue = value!;
                          print("Selected salary: $dropdownValue");
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        DEDropdown(labelText: "Département",items: list, onChanged: (value) {
                          dropdownValue = value!;
                          print("Selected salary: $dropdownValue");
                        }),
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
