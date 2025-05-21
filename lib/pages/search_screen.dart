import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../datas/de_datas.dart';
import '../helper/de_text_field.dart';
import '../helper/search_card.dart';
import '../helper/singleselect_input.dart';
import '../helper/style.dart';
import '../services/user_manager.dart';
import '../utils/time_formatting.dart';
import '../viewmodels/saved_search_view_model.dart';
import 'search_offers_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // ---------------------------------------------------------------------------
  // Fields
  // ---------------------------------------------------------------------------

  late final String userId;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController localisationController = TextEditingController();

  /// Which contract type is selected in the bottom sheet
  String selectedContrat = "";

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    // Retrieve userId from the UserManager
    // Potentially null-check if userId might be null in your real code
    userId = UserManager.instance.userId?.toString() ?? "";
    debugPrint("SearchScreen.initState() -> userId: $userId");

    // Refresh saved searches after build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _refreshSavedSearches();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    localisationController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // UI - Scaffold
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildSavedSearchesBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSearchBottomSheet,
        backgroundColor: appColor,
        child: const Icon(Icons.search, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /// Builds the top app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white70,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: const Text(
        "Recherche",
        style: TextStyle(
          fontSize: 14,
          color: textColor,
          fontFamily: 'semi-bold',
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UI - Body (Saved Searches)
  // ---------------------------------------------------------------------------

  /// Displays the user’s saved searches or loading/empty states
  Widget _buildSavedSearchesBody() {
    return Consumer<SavedSearchesViewModel>(
      builder: (context, viewModel, child) {
        // Show loading indicator if still fetching
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // If not loading but we have no saved searches
        if (viewModel.savedSearches.isEmpty) {
          return _buildEmptySearchesPlaceholder();
        }

        // Otherwise show the list of saved searches
        return RefreshIndicator(
          onRefresh: _refreshSavedSearches,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: viewModel.savedSearches.map((savedSearch) {
                  return SearchCard(
                    query: savedSearch.searchParams.q,
                    localisation: savedSearch.searchParams.localisation,
                    contrat: savedSearch.searchParams.contrat,
                    date: formatDateString(savedSearch.savedAt),
                    onTap: () async {
                      // Navigate to results
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchOffersScreen(
                            query: savedSearch.searchParams.q ?? "",
                            localisation: savedSearch.searchParams.localisation ?? "",
                            selectedContrat: savedSearch.searchParams.contrat ?? "",
                          ),
                        ),
                      );
                      if (result == true) {
                        // Possibly user changed something and we want fresh data
                        await _refreshSavedSearches();
                      }
                    },
                    onDelete: () async {
                      final confirmDelete = await _showDeleteConfirmationDialog(context);
                      if (confirmDelete) {
                        await viewModel.deleteSavedSearch(savedSearch.id);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Shows placeholder when there are no saved searches
  Widget _buildEmptySearchesPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.search_off_rounded, size: 62, color: paragraphColor),
          SizedBox(height: 20),
          Text(
            "Aucune recherche n'est trouvée pour le moment.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: paragraphColor, fontFamily: 'medium'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Bottom Sheet - Add New Search
  // ---------------------------------------------------------------------------

  /// Displays a bottom sheet to create a new search (query, location, contract)
  void _showSearchBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (bottomSheetContext, setState) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text(
                    "Rechercher",
                    style: TextStyle(fontFamily: "semi-bold", fontSize: 18),
                  ),
                  const SizedBox(height: 20),

                  // Job search
                  _buildAutocompleteField(
                    label: "Votre recherche",
                    controller: searchController,
                    items: jobs,
                    onSelected: (val) => searchController.text = val,
                  ),
                  const SizedBox(height: 20),

                  // Location
                  _buildAutocompleteField(
                    label: "Votre Localisation",
                    controller: localisationController,
                    items: locations,
                    onSelected: (val) => localisationController.text = val,
                  ),
                  const SizedBox(height: 20),

                  // Single-select chip for contract
                  SingleSelectChip(
                    contratOptions,
                    onSelectionChanged: (selectedItem) {
                      setState(() {
                        selectedContrat = selectedItem;
                        debugPrint("Selected contrat: $selectedContrat");
                      });
                    },
                  ),
                  const Spacer(),

                  // Create new search
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context); // close bottom sheet

                      // Navigate to the search offers screen
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchOffersScreen(
                            query: searchController.text,
                            localisation: localisationController.text,
                            selectedContrat: selectedContrat,
                          ),
                        ),
                      );
                      if (result == true) {
                        // Possibly user changed something in that screen
                        // and we want to fetch again
                        await _refreshSavedSearches();
                      }
                    },
                    style: appButton(),
                    child: const Text('Nouvelle recherche'),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Helper to build an Autocomplete field
  Widget _buildAutocompleteField({
    required String label,
    required TextEditingController controller,
    required List<String> items,
    required ValueChanged<String> onSelected,
  }) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        final query = textEditingValue.text.toLowerCase();
        return items.where((item) => item.toLowerCase().contains(query));
      },
      onSelected: onSelected,
      fieldViewBuilder: (context, fieldController, focusNode, onSubmitted) {
        return DETextField(
          controller: fieldController,
          labelText: label,
          focusNode: focusNode,
          onChanged: (value) => controller.text = value,
        );
      },
      optionsViewBuilder: (context, onSelectedOption, options) {
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
                  final String option = options.elementAt(index);
                  return GestureDetector(
                    onTap: () => onSelectedOption(option),
                    child: ListTile(title: Text(option)),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Logic - Refresh & Delete
  // ---------------------------------------------------------------------------

  /// Refreshes the user’s saved searches from the server
  Future<void> _refreshSavedSearches() async {
    final viewModel = Provider.of<SavedSearchesViewModel>(context, listen: false);

    if (userId.isEmpty) {
      debugPrint('No valid userId; skipping fetchSavedSearches');
      return;
    }

    debugPrint('Refreshing saved searches for user: $userId...');
    await viewModel.fetchSavedSearches(userId);
    debugPrint('Finished refreshing saved searches. Found: ${viewModel.savedSearches.length}');
  }

  /// Confirms whether to delete a saved search
  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: const Text('Voulez-vous vraiment supprimer cette recherche enregistrée ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
