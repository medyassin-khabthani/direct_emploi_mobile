import 'package:direct_emploi/pages/tabbar_screen.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../datas/de_datas.dart';
import '../helper/full_width_elevated_button.dart';
import '../helper/singleselect_input.dart';
import '../helper/style.dart';
import '../viewmodels/data_fetching_view_model.dart';
import '../viewmodels/saved_search_view_model.dart';
import '../viewmodels/signup_view_model.dart';

class WorkSearchScreen extends StatefulWidget {
  const WorkSearchScreen({Key? key}) : super(key: key);

  @override
  State<WorkSearchScreen> createState() => _WorkSearchScreenState();
}

class _WorkSearchScreenState extends State<WorkSearchScreen> {
  /// Controls page navigation in the PageView
  late final PageController pageController;

  /// Tracks which page (0..3) is displayed
  int currentPage = 0;

  /// User inputs
  final TextEditingController workController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  /// Contract selection
  late String selectedContrat = "";

  /// Loading state for final submission
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentPage);

    /// Pre-fetch job titles from DataFetchingViewModel
    final viewModel = Provider.of<DataFetchingViewModel>(context, listen: false);
    viewModel.fetchJobTitles("");
    // Optionally handle errors or success logic here if needed
  }

  @override
  void dispose() {
    pageController.dispose();
    workController.dispose();
    locationController.dispose();
    emailController.dispose();
    super.dispose();
  }

  /// Go forward one page
  void nextPage() {
    setState(() => currentPage++);
    pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  /// Go back one page
  void previousPage() {
    setState(() => currentPage--);
    pageController.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  /// Build the main UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: _buildMainContent(),
        ),
      ),
    );
  }

  /// Builds the core layout: a PageView + Dots + Next Button
  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pages
        Expanded(
          child: PageView(
            controller: pageController,
            onPageChanged: (int index) {
              setState(() => currentPage = index);
            },
            children: [
              _buildWorkSearchPage(),
              _buildLocationSearchPage(),
              _buildContractSearchPage(),
              _buildEmailPage(),
            ],
          ),
        ),

        // Dots
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

        const SizedBox(height: 20),

        // Next/Finish Button
        ElevatedButton(
          style: appButton(),
          onPressed: isLoading
              ? null
              : () async {
            if (currentPage == 3) {
              // We are on the last page -> create quick account
              await _handleFinalSubmission();
            } else {
              // Otherwise just go to next page
              nextPage();
            }
          },
          child: isLoading
              ? const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
              : Text(currentPage == 3 ? "Terminer" : "Suivant"),
        ),
      ],
    );
  }

  /// Handles the final form submission (page 3: Email)
  Future<void> _handleFinalSubmission() async {
    setState(() => isLoading = true);

    final signupViewModel = Provider.of<SignupViewModel>(context, listen: false);
    final savedSearchesViewModel =
    Provider.of<SavedSearchesViewModel>(context, listen: false);

    await signupViewModel.createQuickAccount(emailController.text);

    if (signupViewModel.error == null) {
      final searchParams = {
        'q': workController.text,
        'localisation': locationController.text,
        'contrat': selectedContrat,
        'offset': "0",
        'limit': "10",
      };

      // Save the search for the newly created user
      final userId = signupViewModel.user!['userId'];
      await savedSearchesViewModel.saveSearch(userId, searchParams);

      if (savedSearchesViewModel.savingSuccess == true) {
        await savedSearchesViewModel.fetchSavedSearches(userId.toString());
        setState(() => isLoading = false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => TabBarScreen()),
        );
      } else {
        // Handle saving failure if needed
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Échec de l'enregistrement de la recherche.")),
        );
      }
    } else {
      // Signup error
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(signupViewModel.error!)),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Individual Pages
  // ---------------------------------------------------------------------------

  Widget _buildWorkSearchPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBackButton(onTap: () => Navigator.pop(context)),
        _buildCircleIcon("assets/images/work.svg"),
        const SizedBox(height: 15.0),
        const Text(
          "Quels métier recherchez-vous ?",
          style: TextStyle(
            fontSize: 18,
            fontFamily: "semi-bold",
            color: textColor,
          ),
        ),
        const SizedBox(height: 15.0),

        // Autocomplete for job titles
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            final query = textEditingValue.text.toLowerCase();
            return jobs.where((job) => job.toLowerCase().contains(query));
          },
          onSelected: (String job) => workController.text = job,
          fieldViewBuilder:
              (context, fieldTextEditingController, fieldFocusNode, onFieldSubmitted) {
            return TextField(
              controller: fieldTextEditingController,
              onChanged: (value) => workController.text = value,
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
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                child: Container(
                  color: headerBackground,
                  width: MediaQuery.of(context).size.width - 86,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final option = options.elementAt(index);
                      return GestureDetector(
                        onTap: () => onSelected(option),
                        child: ListTile(title: Text(option)),
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

  Widget _buildLocationSearchPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBackButton(onTap: previousPage),
        _buildCircleIcon("assets/images/location.svg"),
        const SizedBox(height: 15.0),
        const Text(
          "Vers où recherchez-vous ?",
          style: TextStyle(
            fontSize: 18,
            fontFamily: "semi-bold",
            color: textColor,
          ),
        ),
        const SizedBox(height: 15.0),

        // Autocomplete for locations
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            final query = textEditingValue.text.toLowerCase();
            return locations.where((loc) => loc.toLowerCase().contains(query));
          },
          onSelected: (String loc) => locationController.text = loc,
          fieldViewBuilder:
              (context, fieldTextEditingController, fieldFocusNode, onFieldSubmitted) {
            return TextField(
              controller: fieldTextEditingController,
              onChanged: (value) => locationController.text = value,
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
                prefixIcon: Icon(Icons.location_on_outlined, size: 20, color: placeholderColor),
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
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                child: Container(
                  color: headerBackground,
                  width: MediaQuery.of(context).size.width - 86,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final option = options.elementAt(index);
                      return GestureDetector(
                        onTap: () => onSelected(option),
                        child: ListTile(title: Text(option)),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBackButton(onTap: previousPage),
        _buildCircleIcon("assets/images/contract.svg"),
        const SizedBox(height: 15.0),
        const Text(
          "Quels types de contrat vous intéressent ?",
          style: TextStyle(
            fontSize: 18,
            fontFamily: "semi-bold",
            color: textColor,
          ),
        ),
        const SizedBox(height: 15.0),
        const Text(
          "Veuillez choisir une seule option",
          style: TextStyle(
            fontSize: 14,
            fontFamily: "regular",
            color: textColor,
          ),
        ),
        const SizedBox(height: 15.0),
        // Single-select chip input
        SingleSelectChip(
          contratOptions,
          onSelectionChanged: (selectedItem) {
            setState(() => selectedContrat = selectedItem);
          },
        ),
      ],
    );
  }

  Widget _buildEmailPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBackButton(onTap: previousPage),
        _buildCircleIcon("assets/images/email.svg"),
        const SizedBox(height: 15.0),
        const Text(
          "Quel est votre email ?",
          style: TextStyle(
            fontSize: 18,
            fontFamily: "semi-bold",
            color: textColor,
          ),
        ),
        const SizedBox(height: 15.0),
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
            prefixIcon: Icon(Icons.mail_outline_outlined, size: 20, color: placeholderColor),
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

  // ---------------------------------------------------------------------------
  // Helper Widgets
  // ---------------------------------------------------------------------------

  /// Builds a back arrow button with custom callback
  Widget _buildBackButton({required VoidCallback onTap}) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: onTap,
    );
  }

  /// Builds a circle container with a given SVG in the center
  Widget _buildCircleIcon(String assetPath) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 54.0,
            height: 54.0,
            decoration: BoxDecoration(
              border: Border.all(
                color: strokeColor,
                width: 0.5,
              ),
              shape: BoxShape.circle,
              color: inputBackground,
            ),
          ),
          SvgPicture.asset(assetPath),
        ],
      ),
    );
  }
}
