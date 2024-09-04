import 'package:direct_emploi/pages/search_offers_screen.dart';
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

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final userId = "${UserManager.instance.userId!}";

  TextEditingController searchController = TextEditingController();
  TextEditingController localisationController = TextEditingController();
  String selectedContrat = "";
  String query = "";
  String localisation = "";
  int offset = 0;
  final int limit = 10;

  @override
  void initState() {
    super.initState();
    print("USERID $userId");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshSavedSearches();
    });
  }

  void _showSearchBottomSheet() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Set corner radius to zero
      ),
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("Rechercher", style: TextStyle(fontFamily: "semi-bold", fontSize: 18)),
                  SizedBox(height: 20),
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == "") {
                        return const Iterable<String>.empty();
                      }
                      return jobs.where((String item) {
                        return item
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (String item) {
                      searchController.text = item;
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController fieldTextEditingController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted) {
                      return DETextField(
                        controller: fieldTextEditingController,
                        labelText: "Votre recherche",
                        focusNode:fieldFocusNode ,
                        onChanged: (value) {
                          searchController.text = value;
                        },
                      );
                    },
                    optionsViewBuilder: (BuildContext context,
                        AutocompleteOnSelected<String> onSelected,
                        Iterable<String> options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          child: Container(
                            color: headerBackground,
                            width: MediaQuery.of(context).size.width -
                                86, // Match the width of the parent container
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16), // Add some margin
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
                  // DETextField(
                  //     controller: searchController, labelText: "Votre recherche"),
                  SizedBox(height: 20),
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
                      localisationController.text = item;
                    },
                    fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
                      return DETextField(
                        controller: fieldTextEditingController,
                        labelText: "Votre Localisation",
                        focusNode:fieldFocusNode ,
                        onChanged: (value) {
                          localisationController.text = value;
                        },
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
                  // DETextField(
                  //     controller: localisationController,
                  //     labelText: "Votre Localisation"),
                  SizedBox(height: 20),
                  SingleSelectChip(
                    contratOptions,
                    onSelectionChanged: (selectedItem) {
                      setState(() {
                        selectedContrat = selectedItem;
                        print(selectedContrat);
                      });
                    },
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchOffersScreen(
                            query: searchController.text,
                            localisation: localisationController.text,
                            selectedContrat: selectedContrat,
                          ),
                        ),
                      ).then((val) {
                        if (val == true) {
                          _refreshSavedSearches();
                        }
                      });
                    },
                    style: appButton(),
                    child: Text('Nouvelle recherche'),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: _buildBody(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSearchBottomSheet,
        backgroundColor: appColor,
        child: Icon(Icons.search, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.white70,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(
        "Recherche",
        style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold'),
      ),
    );
  }

  Widget _buildBody() {
    return Scaffold(
      body: Consumer<SavedSearchesViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (viewModel.isLoading && viewModel.savedSearches.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          if (viewModel.savedSearches.isEmpty && !viewModel.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.search_off_rounded,
                    size: 62,
                    color: paragraphColor,
                  ),
                  SizedBox(height: 20),
                  Text(
                    textAlign: TextAlign.center,
                    "Aucune recherche n'est trouvée pour le moment.",
                    style: TextStyle(fontSize: 14, color: paragraphColor, fontFamily: 'medium'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshSavedSearches,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: viewModel.savedSearches.map((savedSearch) {
                    return SearchCard(
                      query: savedSearch.searchParams.q,
                      localisation: savedSearch.searchParams.localisation,
                      contrat: savedSearch.searchParams.contrat,
                      date: formatDateString(savedSearch.savedAt),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchOffersScreen(
                              query: savedSearch.searchParams.q!,
                              localisation: savedSearch.searchParams.localisation!,
                              selectedContrat: savedSearch.searchParams.contrat!,
                            ),
                          ),
                        ).then((val) {
                          if (val == true) {
                            _refreshSavedSearches();
                          }
                        });
                      },
                      onDelete: () async {
                        bool confirmDelete = await _showDeleteConfirmationDialog(context);
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
      ),
    );
  }

  Future<void> _refreshSavedSearches() async {
    print('Refreshing saved searches');
    final viewModel = Provider.of<SavedSearchesViewModel>(context, listen: false);
    await viewModel.fetchSavedSearches(userId);
    print('Finished refreshing saved searches');
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Voulez-vous vraiment supprimer cette recherche enregistrée ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    ) ?? false;
  }
}
