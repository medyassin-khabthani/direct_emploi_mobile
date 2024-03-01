import 'package:direct_emploi/helper/full_width_elevated_button.dart';
import 'package:direct_emploi/helper/style.dart';
import 'package:direct_emploi/helper/singleselect_input.dart';
import 'package:direct_emploi/pages/splash_screen.dart';
import 'package:direct_emploi/pages/tabbar_screen.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WorkSearchScreen extends StatefulWidget {
  const WorkSearchScreen({super.key});

  @override
  State<WorkSearchScreen> createState() => _WorkSearchScreenState();
}

class _WorkSearchScreenState extends State<WorkSearchScreen> {
  int currentPage = 0 ;
  final  _formKeyWork = GlobalKey<FormState>();
  final  _formKeyLocation = GlobalKey<FormState>();
  late PageController pageController;
  final List<String> contratList = ['Contrat', 'CDI', 'CDD','Interim', 'Freelance / Indépédant', 'Alternance','Stage'];
  late String selectedContrat = "";

  @override
  void initState(){
    pageController = PageController(initialPage: currentPage);
    super.initState();
  }
  @override
  void dispose(){
    pageController.dispose();
    super.dispose();
  }
  void nextPage() {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: _buildBody(),
      )) ,
    );
  }


  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: PageView(
            controller: pageController,
            onPageChanged: (int index){
              setState(() {
                currentPage = index;
              });
            },
            children: [

              Form(
              key: _formKeyWork
              ,child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 48.0,),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 54.0,
                        height: 54.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: strokeColor, // Border color
                            width: 0.5,          // Border thickness
                          ),
                          shape: BoxShape.circle,
                          color: inputBackground, // Adjust color as needed
                        ),
                      ),
                      SvgPicture.asset(
                              "assets/images/work.svg"
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0,),
                  const Text("Quels métier recherchez-vous ?",style: TextStyle(
                    fontSize: 18,
                    fontFamily: "semi-bold",
                    color: textColor
                  ),),
                  SizedBox(height: 15,),
                  TextFormField(
                    decoration: const InputDecoration(
                      contentPadding:
                        EdgeInsets.symmetric(horizontal: 15,vertical: 13),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
          
                          borderSide: BorderSide(color: strokeColor)
                      ),
                      filled: true,
                      fillColor: inputBackground,
                      labelText: "Métier, domaine, mots clés",
                      prefixIcon: Icon(Icons.work_outline_outlined,size: 20,color: placeholderColor,),
                      labelStyle: TextStyle(
                        color: placeholderColor,
                        fontSize: 14,
          
                      )
          
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'regular'
                    ),
                    ),
          
          
                ],
              )
              ),
              Form(
                  key: _formKeyLocation
                  ,child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () {
                      pageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);
                    },
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 54.0,
                        height: 54.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: strokeColor, // Border color
                            width: 0.5,          // Border thickness
                          ),
                          shape: BoxShape.circle,
                          color: inputBackground, // Adjust color as needed
                        ),
                      ),
                      SvgPicture.asset(
                          "assets/images/location.svg"
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0,),
                  const Text("Vers où recherchez-vous ?",style: TextStyle(
                      fontSize: 18,
                      fontFamily: "semi-bold",
                      color: textColor
                  ),),
                  SizedBox(height: 15,),
                  TextFormField(
                    decoration: const InputDecoration(
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 15,vertical: 13),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
          
                            borderSide: BorderSide(color: strokeColor)
                        ),
                        filled: true,
                        fillColor: inputBackground,
                        labelText: "Ville, département, Code postal",
                        prefixIcon: Icon(Icons.location_on_outlined,size: 20,color: placeholderColor,),
                        labelStyle: TextStyle(
                          color: placeholderColor,
                          fontSize: 14,
          
                        )
          
                    ),
                    style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'regular'
                    ),
                  ),
          
          
                ],
              )
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () {
                      pageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);
                    },
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 54.0,
                        height: 54.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: strokeColor, // Border color
                            width: 0.5,          // Border thickness
                          ),
                          shape: BoxShape.circle,
                          color: inputBackground, // Adjust color as needed
                        ),
                      ),
                      SvgPicture.asset(
                          "assets/images/contract.svg"
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0,),
                  const Text("Quels types de contrat vous intéressent ?",style: TextStyle(
                      fontSize: 18,
                      fontFamily: "semi-bold",
                      color: textColor
                  ),),
                  const SizedBox(height: 15,),
                  const Text("Veuillez choisir une seule option",style: TextStyle(
                      fontSize: 14,
                      fontFamily: "regular",
                      color: textColor
                  ),),
                  const SizedBox(height: 15,),
                  SingleSelectChip(contratList,
                    onSelectionChanged: (selectedItem) {
                    setState(() {
                      selectedContrat = selectedItem;
                    });
                  },)
          
          
                ],
              ),
              Form(
                  key: _formKeyLocation
                  ,child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () {
                      pageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);
                    },
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 54.0,
                        height: 54.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: strokeColor, // Border color
                            width: 0.5,          // Border thickness
                          ),
                          shape: BoxShape.circle,
                          color: inputBackground, // Adjust color as needed
                        ),
                      ),
                      SvgPicture.asset(
                          "assets/images/email.svg"
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0,),
                  const Text("Quel est votre email ?",style: TextStyle(
                      fontSize: 18,
                      fontFamily: "semi-bold",
                      color: textColor
                  ),),
                  SizedBox(height: 15,),
                  TextFormField(
                    decoration: const InputDecoration(
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 15,vertical: 13),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),

                            borderSide: BorderSide(color: strokeColor)
                        ),
                        filled: true,
                        fillColor: inputBackground,
                        labelText: "exemple@directemploi.fr",
                        prefixIcon: Icon(Icons.mail_outline_outlined,size: 20,color: placeholderColor,),
                        labelStyle: TextStyle(
                          color: placeholderColor,
                          fontSize: 14,

                        )

                    ),
                    style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'regular'
                    ),
                  ),


                ],
              )
              ),
            ],
          ),
        ),
        Center(
          child: DotsIndicator(
            dotsCount: 4,
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
        const SizedBox(height: 20,),
        FullWidthElevatedButton(text: currentPage == 3 ? "Terminer": "Suivant", onPressed: (){
          if(currentPage == 3){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => TabBarScreen(),
              ),
            );
          }
          pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);
        })
      ],
    );
  }

}