import 'package:direct_emploi/helper/de_back_button.dart';
import 'package:direct_emploi/pages/tabbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../datas/de_datas.dart';
import '../helper/de_text_field.dart';
import '../helper/offre_card.dart';
import '../helper/singleselect_input.dart';
import '../helper/style.dart';
import '../pages/single_offer_screen.dart';
import '../services/user_manager.dart';
import '../utils/time_formatting.dart';
import '../utils/string_formatting.dart';
import '../viewmodels/favorite_view_model.dart';
import '../viewmodels/offre_view_model.dart';
import '../viewmodels/saved_search_view_model.dart';

class SearchOffersScreen extends StatefulWidget {
  final String query;
  final String localisation;
  final String selectedContrat;

  const SearchOffersScreen(
      {super.key,
        required this.query,
        required this.localisation,
        required this.selectedContrat});

  @override
  State<SearchOffersScreen> createState() => _SearchOffersScreenState();
}

class _SearchOffersScreenState extends State<SearchOffersScreen> {
  String newSelectedContrat = "";
  String newQuery = "";
  String newLocalisation = "";
  String sortOption = "pertinence";

  int offset = 0;
  final int limit = 10;
  final ScrollController _scrollController = ScrollController();
  bool isAtTop = true;
  TextEditingController searchController = TextEditingController();
  TextEditingController localisationController = TextEditingController();
  UserManager userManager = UserManager.instance;

  @override
  void initState() {
    super.initState();
    newSelectedContrat = widget.selectedContrat;
    newQuery = widget.query;
    newLocalisation = widget.localisation;

    final viewModel = Provider.of<OffreViewModel>(context, listen: false);
    final favoriteViewModel = Provider.of<FavoriteViewModel>(context, listen: false);
    favoriteViewModel.fetchSavedOffers(userManager.userId!);
    _fetchOffers();

    _scrollController.addListener(_scrollListener);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !viewModel.isLoading) {
        setState(() {
          offset += limit;
        });
        if (sortOption == "date") {
          viewModel.fetchMoreOffersByDate(userManager.userId!, {
            "q": newQuery,
            "localisation": newLocalisation,
            "contrat": newSelectedContrat
          }, offset, limit);
        } else {
          viewModel.fetchMoreOffers(userManager.userId!, {
            "q": newQuery,
            "localisation": newLocalisation,
            "contrat": newSelectedContrat
          }, offset, limit);
        }
      }
    });
  }

  void _scrollListener() {
    if (_scrollController.offset <= _scrollController.position.minScrollExtent && !isAtTop) {
      setState(() {
        isAtTop = true;
      });
    } else if (_scrollController.offset > _scrollController.position.minScrollExtent && isAtTop) {
      setState(() {
        isAtTop = false;
      });
    }
  }

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _refreshOffers() async {
    final viewModel = Provider.of<OffreViewModel>(context, listen: false);
    setState(() {
      offset = 0;
    });
    await _fetchOffers();
  }

  Future<void> _fetchOffers() async {
    final viewModel = Provider.of<OffreViewModel>(context, listen: false);
    if (sortOption == "date") {
      await viewModel.fetchOffersByDate(userManager.userId!, {
        "q": newQuery,
        "localisation": newLocalisation,
        "contrat": newSelectedContrat
      }, offset, limit);
    } else {
      await viewModel.fetchOffers(userManager.userId!, {
        "q": newQuery,
        "localisation": newLocalisation,
        "contrat": newSelectedContrat
      }, offset, limit);
    }
  }

  void _showSearchBottomSheet() {
    final savedSearchViewModel = Provider.of<SavedSearchesViewModel>(context, listen: false);
    final offreViewModel = Provider.of<OffreViewModel>(context, listen: false);

    searchController.text = newQuery;
    localisationController.text = newLocalisation;

    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Set corner radius to zero
      ),
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text("Modifier ma recherche", style: TextStyle(fontFamily: "semi-bold", fontSize: 18)),
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
                  fieldTextEditingController.text = searchController.text;
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
                  fieldTextEditingController.text = localisationController.text;
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
              SizedBox(height: 20),
              SingleSelectChip(
                contratOptions,
                initialSelectedKey: newSelectedContrat,
                onSelectionChanged: (selectedItem) {
                  setState(() {
                    newSelectedContrat = selectedItem;
                  });
                },
              ),
              Spacer(),
              ElevatedButton(
                onPressed: offreViewModel.isLoading ? null : () async {
                  setState(() {
                    newQuery = searchController.text;
                    newLocalisation = localisationController.text;
                  });

                  // Update the saved search
                  await savedSearchViewModel.updateSavedSearch(
                      "${userManager.userId!}",
                      offreViewModel.idSearch, {
                    "q": newQuery,
                    "localisation": newLocalisation,
                    "contrat": newSelectedContrat,
                  });

                  // Fetch updated offers
                  await _fetchOffers();

                  if (!offreViewModel.isError) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Une erreur est survenue")),
                    );
                  }
                },
                style: appButton(),
                child: offreViewModel.isLoading
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : Text('Modifier'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSortOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Trier par"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile<String>(
                title: const Text('Pertinence'),
                value: 'pertinence',
                groupValue: sortOption,
                onChanged: (String? value) {
                  setState(() {
                    sortOption = value!;
                  });
                  Navigator.pop(context);
                  _refreshOffers();
                },
              ),
              RadioListTile<String>(
                title: const Text('Date'),
                value: 'date',
                groupValue: sortOption,
                onChanged: (String? value) {
                  setState(() {
                    sortOption = value!;
                  });
                  Navigator.pop(context);
                  _refreshOffers();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isAtTop
          ? null
          : Container(
        margin: EdgeInsets.only(bottom: 0),
        child: FloatingActionButton(
          mini: true,
          onPressed: _scrollToTop,
          child: Icon(Icons.arrow_upward_rounded, color: appColor, size: 24),
          backgroundColor: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      appBar: _buildAppbar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: _buildBody(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.white70,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: DEBackButton(),
      title: Text(
        buildTitleString(newQuery, newLocalisation, newSelectedContrat),
        style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold'),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.edit_note, color: appColor),
          onPressed: _showSearchBottomSheet,
        ),

      ],
    );
  }

  Widget _buildBody() {
    return Consumer2<OffreViewModel, FavoriteViewModel>(
      builder: (context, viewModel, favoriteViewModel, child) {
        if (viewModel.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if ( viewModel.offres.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.work,
                  size: 62,
                  color: paragraphColor,
                ),
                SizedBox(height: 20),
                Text(
                  textAlign: TextAlign.center,
                  "Désolé, nous n'avons pas trouvé d'offres qui correspondent à vos critères.",
                  style: TextStyle(fontSize: 14, color: paragraphColor, fontFamily: 'medium'),
                ),
                TextButton(onPressed: (){
                  _showSearchBottomSheet();
                }, child: Text("Modifier ma recherche"))
              ],
            ),
          );
        } else {
          return RefreshIndicator(
            onRefresh: _refreshOffers,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${viewModel.total} ",
                                    style: TextStyle(fontSize: 16, fontFamily: "semi-bold", color: textColor),
                                  ),
                                  TextSpan(
                                    text: 'offres trouvés',
                                    style: TextStyle(fontSize: 16, fontFamily: "medium", color: textColor),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.filter_list_outlined, color: paragraphColor),
                              onPressed: _showSortOptions,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: viewModel.offres.map((offer) {
                      bool isApplied = viewModel.appliedOffers.contains(offer.id);
                      return Opacity(
                        opacity: isApplied ? 0.6 : 1.0,
                        child: OffreCard(
                          companyLogoPath: "https://www.directemploi.com/uploads/logos/${offer.company.logo}",
                          jobTitle: "${offer.title!} - ${offer.company.name}",
                          reference: offer.reference!,
                          date: formatLocationDate(offer.location.region!, offer.location.city!, offer.dateSoumission!),
                          jobDescription: limitToLines(offer.mission!, 2, 150),
                          tags: [offer.contractType!, offer.sector!],
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingleOfferScreen(
                                  offerId: offer.id.toString(),
                                  isSameCompany: false,
                                ),
                              ),
                            ).then((val) {
                              if (val == true) {
                                _refreshSavedOffres();
                              }
                            });
                          },
                          isFavorite: favoriteViewModel.savedOffers.contains(offer.id),
                          onFavoriteToggle: () async {
                            if (favoriteViewModel.savedOffers.contains(offer.id)) {
                              await favoriteViewModel.unsaveOffer(userManager.userId!, offer.id);
                            } else {
                              await favoriteViewModel.saveOffer(userManager.userId!, offer.id);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  if (viewModel.isLoadingMore) Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> _refreshSavedOffres() async {
    print('Refreshing saved Offres');
    final viewModel = Provider.of<FavoriteViewModel>(context, listen: false);
    await viewModel.fetchSavedOffers(userManager.userId!);
    print('Finished refreshing saved Offres');
  }
}

String limitToLines(String text, int maxLines, int maxLength) {
  if (text.length <= maxLength) {
    return text;
  }

  int endIndex = maxLength;
  for (int i = 0; i < maxLines; i++) {
    int newIndex = text.indexOf('\n', endIndex);
    if (newIndex == -1 || newIndex >= maxLength) {
      break;
    }
    endIndex = newIndex + 1;
  }

  if (endIndex < text.length) {
    return '${text.substring(0, endIndex).trim()}...';
  } else {
    return text;
  }
}
