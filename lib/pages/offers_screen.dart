import 'package:direct_emploi/viewmodels/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datas/de_datas.dart';
import '../helper/de_text_field.dart';
import '../helper/singleselect_input.dart';
import '../helper/style.dart';
import '../helper/offre_card.dart';
import '../pages/single_offer_screen.dart';
import '../services/user_manager.dart';
import '../utils/time_formatting.dart';
import '../viewmodels/offre_view_model.dart';
import '../viewmodels/favorite_view_model.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  int offset = 0;
  final int limit = 10;
  final ScrollController _scrollController = ScrollController();
  bool isAtTop = true;
  TextEditingController searchController = TextEditingController();
  TextEditingController localisationController = TextEditingController();
  String selectedContrat = "";
  String query = "";
  String localisation = "";
  UserManager userManager = UserManager.instance;
  String sortOption = "pertinence";
  String? based;
  bool customSearch = false;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<OffreViewModel>(context, listen: false);
    _initSearch();

    viewModel.fetchAppliedOffers(userManager.userId!);

    _scrollController.addListener(_scrollListener);
    _scrollController.addListener(_loadMoreListener);
  }

  void _initSearch() {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    final viewModel = Provider.of<OffreViewModel>(context, listen: false);

    profileViewModel.getUserConfiguration().then((_) {
      if (profileViewModel.userConfiguration != null) {
        setState(() {
          based =
              profileViewModel.userConfiguration!.configuration.based ?? 'none';
        });
        if (based == "profil") {
          setState(() {
            query = profileViewModel.userConfiguration!.configuration.q!;
            localisation =
                profileViewModel.userConfiguration!.configuration.localisation!;
          });
        }
        if (based == "cv") {
          setState(() {
            query = profileViewModel.userConfiguration!.configuration.q!;
          });
        }
        if (based == "none") {
          setState(() {
            query = "";
          });
        }
      }
      viewModel.fetchOffersWithoutSave(
          userManager.userId!,
          {
            "q": query,
            "localisation": localisation,
            "contrat": selectedContrat
          },
          offset,
          limit);
    });
    setState(() {
      customSearch = false;
    });
  }

  void _scrollListener() {
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !isAtTop) {
      setState(() {
        isAtTop = true;
      });
    } else if (_scrollController.offset >
            _scrollController.position.minScrollExtent &&
        isAtTop) {
      setState(() {
        isAtTop = false;
      });
    }
  }

  void _loadMoreListener() {
    final viewModel = Provider.of<OffreViewModel>(context, listen: false);
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !viewModel.isLoading) {
      setState(() {
        offset += limit;
      });
      if (sortOption == "date") {
        viewModel.fetchMoreOffersWithoutSaveByDate(
            userManager.userId!,
            {
              "q": query,
              "localisation": localisation,
              "contrat": selectedContrat
            },
            offset,
            limit);
      } else {
        viewModel.fetchMoreOffersWithoutSave(
            userManager.userId!,
            {
              "q": query,
              "localisation": localisation,
              "contrat": selectedContrat
            },
            offset,
            limit);
      }
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
    if (sortOption == "date") {
      await viewModel.fetchOffersWithoutSaveByDate(
          userManager.userId!,
          {
            "q": query,
            "localisation": localisation,
            "contrat": selectedContrat
          },
          offset,
          limit);
    } else {
      await viewModel.fetchOffersWithoutSave(
          userManager.userId!,
          {
            "q": query,
            "localisation": localisation,
            "contrat": selectedContrat
          },
          offset,
          limit);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.removeListener(_loadMoreListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _showSearchBottomSheet() {
    final viewModel = Provider.of<OffreViewModel>(context, listen: false);

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
              Text("Rechercher",
                  style: TextStyle(fontFamily: "semi-bold", fontSize: 18)),
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
                  setState(() {
                    customSearch = true;
                    query = searchController.text;
                    localisation = localisationController.text;
                  });
                  if (sortOption == "date") {
                    viewModel.fetchOffersWithoutSaveByDate(
                        userManager.userId!,
                        {
                          "q": query,
                          "localisation": localisation,
                          "contrat": selectedContrat
                        },
                        offset,
                        limit);
                  } else {
                    viewModel.fetchOffersWithoutSave(
                        userManager.userId!,
                        {
                          "q": query,
                          "localisation": localisation,
                          "contrat": selectedContrat
                        },
                        offset,
                        limit);
                  }
                  if (!viewModel.isError) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Une erreur est survenue")),
                    );
                  }
                },
                style: appButton(),
                child: Text('Nouvelle recherche'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isAtTop
          ? null
          : Container(
              margin: EdgeInsets.only(bottom: 0),
              child: FloatingActionButton(
                mini: true,
                onPressed: _scrollToTop,
                child:
                    Icon(Icons.arrow_upward_rounded, color: appColor, size: 24),
                backgroundColor: Colors.white,
              ),
            ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
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
      leading: customSearch == true
          ? IconButton(
              onPressed: () {
                _initSearch();
              },
              icon: Icon(Icons.close_rounded),
            )
          : SizedBox(),
      title: Text(
        "Liste des emplois",
        style:
            TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold'),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: appColor),
          onPressed: _showSearchBottomSheet,
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Consumer2<OffreViewModel, FavoriteViewModel>(
      builder: (context, offreViewModel, favoriteViewModel, child) {
        if (offreViewModel.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (offreViewModel.offres.isEmpty) {
          return Column(children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${offreViewModel.total} ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "semi-bold",
                                      color: textColor),
                                ),
                                TextSpan(
                                  text: 'offres trouvés',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "medium",
                                      color: textColor),
                                ),
                              ],
                            ),
                          ),
                          based == 'profil' && customSearch == false
                              ? Text(
                                  "Basé sur votre profil",
                                  style: TextStyle(
                                      fontSize: 12, fontFamily: 'regular'),
                                )
                              : SizedBox(),
                          based == 'cv' && customSearch == false
                              ? Text(
                                  "Basé sur votre cv",
                                  style: TextStyle(
                                      fontSize: 12, fontFamily: 'regular'),
                                )
                              : SizedBox(),
                          if (customSearch == true)
                            Text(
                              "Basé sur votre recherche",
                              style: TextStyle(
                                  fontSize: 12, fontFamily: 'regular'),
                            )
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.filter_list_outlined,
                            color: paragraphColor),
                        onPressed: _showSortOptions,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
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
                      style: TextStyle(
                          fontSize: 14,
                          color: paragraphColor,
                          fontFamily: 'medium'),
                    ),
                  ],
                ),
              ),
            )
          ]);
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "${offreViewModel.total} ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: "semi-bold",
                                            color: textColor),
                                      ),
                                      TextSpan(
                                        text: 'offres trouvés',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: "medium",
                                            color: textColor),
                                      ),
                                    ],
                                  ),
                                ),
                                based == 'profil' && customSearch == false
                                    ? Text(
                                        "Basé sur votre profil",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'regular'),
                                      )
                                    : SizedBox(),
                                based == 'cv' && customSearch == false
                                    ? Text(
                                        "Basé sur votre cv",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'regular'),
                                      )
                                    : SizedBox(),
                                if (customSearch == true)
                                  Text(
                                    "Basé sur votre recherche",
                                    style: TextStyle(
                                        fontSize: 12, fontFamily: 'regular'),
                                  )
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.filter_list_outlined,
                                  color: paragraphColor),
                              onPressed: _showSortOptions,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: offreViewModel.offres.map((offer) {
                      bool isApplied =
                          offreViewModel.appliedOffers.contains(offer.id);
                      return Opacity(
                        opacity: isApplied ? 0.6 : 1.0,
                        child: OffreCard(
                          companyLogoPath:
                              "https://www.directemploi.com/uploads/logos/${offer.company.logo}",
                          jobTitle: "${offer.title!} - ${offer.company.name}",
                          reference: offer.reference!,
                          date: formatLocationDate(offer.location.region!,
                              offer.location.city!, offer.dateSoumission!),
                          jobDescription: limitToLines(offer.mission!, 2, 150),
                          tags: [offer.contractType!, offer.sector!],
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SingleOfferScreen(
                                        offerId: offer.id.toString(),
                                        isSameCompany: false,
                                      )),
                            ).then((val) {
                              if (val == true) {
                                _refreshSavedOffres();
                                _refreshOffers();
                              }
                            });
                          },
                          isFavorite:
                              favoriteViewModel.savedOffers.contains(offer.id),
                          onFavoriteToggle: () async {
                            if (favoriteViewModel.savedOffers
                                .contains(offer.id)) {
                              await favoriteViewModel.unsaveOffer(
                                  userManager.userId!, offer.id);
                            } else {
                              await favoriteViewModel.saveOffer(
                                  userManager.userId!, offer.id);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  if (offreViewModel.isLoadingMore)
                    Center(child: CircularProgressIndicator()),
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
