import 'package:direct_emploi/pages/tabbar_screen.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import '../datas/de_datas.dart';
import '../helper/full_width_elevated_button.dart';
import '../helper/singleselect_input.dart';
import '../viewmodels/data_fetching_view_model.dart';
import '../helper/style.dart';
import '../viewmodels/saved_search_view_model.dart';
import '../viewmodels/signup_view_model.dart';

class WorkSearchScreen extends StatefulWidget {
  const WorkSearchScreen({super.key});

  @override
  State<WorkSearchScreen> createState() => _WorkSearchScreenState();
}

class _WorkSearchScreenState extends State<WorkSearchScreen> {
  int currentPage = 0;
  late PageController pageController;
  TextEditingController workController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final List<String> contratList = ['Tous', 'CDI', 'CDD', 'Interim', 'Freelance / Indépédant', 'Alternance', 'Stage'];
  late String selectedContrat = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentPage);

    final viewModel = Provider.of<DataFetchingViewModel>(context, listen: false);
    viewModel.fetchJobTitles("").then((value) {
    print(viewModel.jobTitles);
    });


  }

  @override
  void dispose() {
    pageController.dispose();
    workController.dispose();
    locationController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void nextPage() {
    setState(() {
      currentPage++;
    });
    pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  void previousPage() {
    setState(() {
      currentPage--;
    });
    pageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: _buildBody(),
        ),
      ),
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
            onPageChanged: (int index) {
              setState(() {
                currentPage = index;
              });
            },
            children: [
              _buildWorkSearchPage(),
              _buildLocationSearchPage(),
              _buildContractSearchPage(),
              _buildEmailPage(),
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
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20,),
        ElevatedButton(
          style:appButton(),
          onPressed:isLoading
              ? null
              : ()  async {
            if (currentPage == 3) {
              setState(() {
                isLoading = true;
              });
              final viewModel = Provider.of<SignupViewModel>(context, listen: false);
              final searchViewModel = Provider.of<SavedSearchesViewModel>(context, listen: false);
              await viewModel.createQuickAccount(emailController.text);
              if (viewModel.error == null) {
                print("email:${emailController.text}");
                print("Work: ${workController.text}");
                print("Location: ${locationController.text}");
                print("Selected Contract: $selectedContrat");
                final searchParams = {
                  'q': workController.text,
                  'localisation': locationController.text,
                  'contrat': selectedContrat,
                  'offset': "0",
                  'limit':"10",
                };
                await searchViewModel.saveSearch(viewModel.user!['userId'],searchParams);

                if (searchViewModel.savingSuccess == true){
                  setState(() {
                    isLoading = false;
                  });
                  await searchViewModel.fetchSavedSearches(viewModel.user!['userId'].toString());
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TabBarScreen(),
                    ),
                  );
                }
              } else {
                setState(() {
                  isLoading = false;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(viewModel.error!),
                  ),
                );
              }
            } else {
              nextPage();
            }
          }, child: isLoading
            ? CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        )
            :Text(currentPage == 3 ? "Terminer" : "Suivant"),
        ),
      ],
    );
  }

  Widget _buildWorkSearchPage() {
    return Consumer<DataFetchingViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.pop(context),
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
                SvgPicture.asset("assets/images/work.svg"),
              ],
            ),
            const SizedBox(height: 15.0,),
            const Text(
              "Quels métier recherchez-vous ?",
              style: TextStyle(
                fontSize: 18,
                fontFamily: "semi-bold",
                color: textColor,
              ),
            ),
            SizedBox(height: 15,),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == "") {
                  return const Iterable<String>.empty();
                }
                return jobs.where((String item) {
                  return item.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String item) {
                workController.text = item;
              },
              fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
                return TextField(
                  controller: fieldTextEditingController,
                  onChanged: (value) {
                    workController.text = value;
                  },
                  focusNode: fieldFocusNode,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Métier, domaine, mots clés",
                    prefixIcon: Icon(Icons.work_outline_outlined, size: 20, color: Colors.grey),
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'regular',
                  ),
                );
              },
              optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    child: Container(
                        color:headerBackground,
                      width: MediaQuery.of(context).size.width - 86, // Match the width of the parent container
                      margin: const EdgeInsets.symmetric(horizontal: 16), // Add some margin
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String option = options.elementAt(index);
                          return GestureDetector(
                            onTap: () {
                              onSelected(option);
                            },
                            child: ListTile(
                              title: Text(option),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildLocationSearchPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: previousPage,
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
            SvgPicture.asset("assets/images/location.svg"),
          ],
        ),
        const SizedBox(height: 15.0,),
        const Text(
          "Vers où recherchez-vous ?",
          style: TextStyle(
            fontSize: 18,
            fontFamily: "semi-bold",
            color: textColor,
          ),
        ),
        SizedBox(height: 15,),
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == "") {
              return const Iterable<String>.empty();
            }
            return locations.where((String item) {
              return item.toLowerCase().contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String item) {
            locationController.text = item;
          },
          fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
            return TextField(
              controller: fieldTextEditingController,
              onChanged: (value) {
                locationController.text = value;
              },
              focusNode: fieldFocusNode,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: strokeColor),
                ),
                filled: true,
                fillColor: inputBackground,
                labelText: "Ville, département, région",
                prefixIcon: Icon(Icons.location_on_outlined, size: 20, color: placeholderColor,),
                labelStyle: TextStyle(
                  color: placeholderColor,
                  fontSize: 14,
                ),
              ),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'regular',
              ),
            );
          },
          optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                child: Container(
                  color:headerBackground,
                  width: MediaQuery.of(context).size.width - 86, // Match the width of the parent container
                  margin: const EdgeInsets.symmetric(horizontal: 16), // Add some margin
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          onSelected(option);
                        },
                        child: ListTile(
                          title: Text(option),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildContractSearchPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: previousPage,
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
            SvgPicture.asset("assets/images/contract.svg"),
          ],
        ),
        const SizedBox(height: 15.0,),
        const Text(
          "Quels types de contrat vous intéressent ?",
          style: TextStyle(
            fontSize: 18,
            fontFamily: "semi-bold",
            color: textColor,
          ),
        ),
        const SizedBox(height: 15,),
        const Text(
          "Veuillez choisir une seule option",
          style: TextStyle(
            fontSize: 14,
            fontFamily: "regular",
            color: textColor,
          ),
        ),
        const SizedBox(height: 15,),
        SingleSelectChip(
          contratOptions,
          onSelectionChanged: (selectedItem) {
            setState(() {
              selectedContrat = selectedItem;
              print(selectedContrat);
            });
          },
        ),
      ],
    );
  }

  Widget _buildEmailPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: previousPage,
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
            SvgPicture.asset("assets/images/email.svg"),
          ],
        ),
        const SizedBox(height: 15.0,),
        const Text(
          "Quel est votre email ?",
          style: TextStyle(
            fontSize: 18,
            fontFamily: "semi-bold",
            color: textColor,
          ),
        ),
        SizedBox(height: 15,),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: strokeColor),
            ),
            filled: true,
            fillColor: inputBackground,
            labelText: "exemple@directemploi.fr",
            prefixIcon: Icon(Icons.mail_outline_outlined, size: 20, color: placeholderColor,),
            labelStyle: TextStyle(
              color: placeholderColor,
              fontSize: 14,
            ),
          ),
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'regular',
          ),
        ),
      ],
    );
  }
}
