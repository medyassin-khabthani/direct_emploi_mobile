import 'package:direct_emploi/viewmodels/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../datas/de_datas.dart';
import '../helper/de_text_field.dart';
import '../helper/offre_card.dart';
import '../helper/singleselect_input.dart';
import '../helper/style.dart';
import '../pages/single_offer_screen.dart';
import '../services/user_manager.dart';
import '../utils/time_formatting.dart';
import '../viewmodels/offre_view_model.dart';
import '../viewmodels/favorite_view_model.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({Key? key}) : super(key: key);

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  // ---------------------------------------------------------------------------
  // State & Controllers
  // ---------------------------------------------------------------------------
  final ScrollController _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController localisationController = TextEditingController();

  bool isAtTop = true;
  bool customSearch = false;

  // Pagination
  int offset = 0;
  final int limit = 10;

  // Query params
  String query = "";
  String localisation = "";
  String selectedContrat = "";
  String sortOption = "pertinence"; // "pertinence" or "date"

  // We store the "based" config from user preferences (profil / cv / none)
  String? based;

  // Singleton instance
  UserManager userManager = UserManager.instance;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    final offreVM = Provider.of<OffreViewModel>(context, listen: false);

    // Load user-applied offers
    offreVM.fetchAppliedOffers(userManager.userId!);

    // Initialize with the search from user config
    _initSearch();

    // Listeners for scrolling
    _scrollController.addListener(_scrollListener);
    _scrollController.addListener(_loadMoreListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.removeListener(_loadMoreListener);
    _scrollController.dispose();
    searchController.dispose();
    localisationController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Initialization & Data Loading
  // ---------------------------------------------------------------------------
  /// Initializes query/localisation from user configuration and fetches offers
  void _initSearch() {
    final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
    final offreVM = Provider.of<OffreViewModel>(context, listen: false);

    profileVM.getUserConfiguration().then((_) {
      if (profileVM.userConfiguration != null) {
        based = profileVM.userConfiguration!.configuration.based ?? 'none';

        // If based on profile or CV, fill query / localisation from config
        if (based == "profil") {
          query = profileVM.userConfiguration!.configuration.q ?? "";
          localisation =
              profileVM.userConfiguration!.configuration.localisation ?? "";
        } else if (based == "cv") {
          query = profileVM.userConfiguration!.configuration.q ?? "";
        } else {
          query = "";
          localisation = "";
        }
      }

      // Fetch offers
      offreVM.fetchOffersWithoutSave(
        userManager.userId!,
        {"q": query, "localisation": localisation, "contrat": selectedContrat},
        offset,
        limit,
      );
    });

    // We haven't customized the search yet
    // (Though you could also do setState(() => customSearch = false) here)
    customSearch = false;
  }

  // ---------------------------------------------------------------------------
  // Scrolling Logic
  // ---------------------------------------------------------------------------
  void _scrollListener() {
    if (_scrollController.offset <=
        _scrollController.position.minScrollExtent &&
        !isAtTop) {
      setState(() => isAtTop = true);
    } else if (_scrollController.offset >
        _scrollController.position.minScrollExtent &&
        isAtTop) {
      setState(() => isAtTop = false);
    }
  }

  /// Loads the next page when we reach the bottom
  void _loadMoreListener() {
    final offreVM = Provider.of<OffreViewModel>(context, listen: false);
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !offreVM.isLoading) {
      offset += limit;
      if (sortOption == "date") {
        offreVM.fetchMoreOffersWithoutSaveByDate(
          userManager.userId!,
          {"q": query, "localisation": localisation, "contrat": selectedContrat},
          offset,
          limit,
        );
      } else {
        offreVM.fetchMoreOffersWithoutSave(
          userManager.userId!,
          {"q": query, "localisation": localisation, "contrat": selectedContrat},
          offset,
          limit,
        );
      }
    }
  }

  /// Scrolls up
  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Partial Refresh: Favorites + Applied
  // ---------------------------------------------------------------------------
  Future<void> _refreshSavedOffres() async {
    final favVM = Provider.of<FavoriteViewModel>(context, listen: false);
    await favVM.fetchSavedOffers(userManager.userId!);
  }

  Future<void> _refreshAppliedOffers() async {
    final offreVM = Provider.of<OffreViewModel>(context, listen: false);
    await offreVM.fetchAppliedOffers(userManager.userId!);
  }

  // ---------------------------------------------------------------------------
  // Full Refresh (Pull to Refresh or Sort)
  // ---------------------------------------------------------------------------
  Future<void> _refreshOffers() async {
    final offreVM = Provider.of<OffreViewModel>(context, listen: false);
    offset = 0;
    if (sortOption == "date") {
      await offreVM.fetchOffersWithoutSaveByDate(
        userManager.userId!,
        {"q": query, "localisation": localisation, "contrat": selectedContrat},
        offset,
        limit,
      );
    } else {
      await offreVM.fetchOffersWithoutSave(
        userManager.userId!,
        {"q": query, "localisation": localisation, "contrat": selectedContrat},
        offset,
        limit,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Searching & Sorting
  // ---------------------------------------------------------------------------
  void _showSearchBottomSheet() {
    final offreVM = Provider.of<OffreViewModel>(context, listen: false);

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Text("Rechercher",
                  style: TextStyle(fontFamily: "semi-bold", fontSize: 18)),
              const SizedBox(height: 20),

              // Autocomplete for jobs
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return jobs.where((String item) => item
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()));
                },
                onSelected: (String item) => searchController.text = item,
                fieldViewBuilder:
                    (context, fieldTextController, focusNode, onFieldSubmitted) {
                  return DETextField(
                    controller: fieldTextController,
                    labelText: "Votre recherche",
                    focusNode: focusNode,
                    onChanged: (value) => searchController.text = value,
                  );
                },
              ),
              const SizedBox(height: 20),

              // Autocomplete for locations
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return locations.where((String item) => item
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()));
                },
                onSelected: (String item) => localisationController.text = item,
                fieldViewBuilder:
                    (context, fieldTextController, focusNode, onFieldSubmitted) {
                  return DETextField(
                    controller: fieldTextController,
                    labelText: "Votre Localisation",
                    focusNode: focusNode,
                    onChanged: (value) => localisationController.text = value,
                  );
                },
              ),
              const SizedBox(height: 20),

              SingleSelectChip(
                contratOptions,
                onSelectionChanged: (selectedItem) {
                  setState(() => selectedContrat = selectedItem);
                },
              ),
              const Spacer(),
              ElevatedButton(
                style: appButton(),
                onPressed: () async {
                  setState(() {
                    customSearch = true;
                    query = searchController.text;
                    localisation = localisationController.text;
                  });

                  offset = 0; // reset offset
                  if (sortOption == "date") {
                    await offreVM.fetchOffersWithoutSaveByDate(
                      userManager.userId!,
                      {
                        "q": query,
                        "localisation": localisation,
                        "contrat": selectedContrat
                      },
                      offset,
                      limit,
                    );
                  } else {
                    await offreVM.fetchOffersWithoutSave(
                      userManager.userId!,
                      {
                        "q": query,
                        "localisation": localisation,
                        "contrat": selectedContrat
                      },
                      offset,
                      limit,
                    );
                  }

                  if (!offreVM.isError) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Une erreur est survenue")),
                    );
                  }
                },
                child: const Text('Nouvelle recherche'),
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
          title: const Text("Trier par"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile<String>(
                title: const Text('Pertinence'),
                value: 'pertinence',
                groupValue: sortOption,
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() => sortOption = value);
                    Navigator.pop(context);
                    _refreshOffers();
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('Date'),
                value: 'date',
                groupValue: sortOption,
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() => sortOption = value);
                    Navigator.pop(context);
                    _refreshOffers();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isAtTop
          ? null
          : FloatingActionButton(
        mini: true,
        backgroundColor: Colors.white,
        onPressed: _scrollToTop,
        child: Icon(Icons.arrow_upward_rounded, color: appColor, size: 24),
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
      leading: customSearch
          ? IconButton(
        onPressed: () {
          /// The fix: hide the X by setting customSearch to false
          setState(() => customSearch = false);
          _initSearch(); // resets search to user config
        },
        icon: const Icon(Icons.close_rounded),
      )
          : const SizedBox(),
      title: const Text(
        "Liste des emplois",
        style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold'),
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
      builder: (context, offreVM, favoriteVM, child) {
        if (offreVM.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (offreVM.offres.isEmpty) {
          return _buildEmptyOffers(offreVM);
        } else {
          return RefreshIndicator(
            onRefresh: _refreshOffers,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildOffersHeader(offreVM),
                  Column(
                    children: offreVM.offres.map((offer) {
                      final bool isApplied = offreVM.appliedOffers.contains(offer.id);
                      return Opacity(
                        opacity: isApplied ? 0.6 : 1.0,
                        child: OffreCard(
                          companyLogoPath:
                          "https://www.directemploi.com/uploads/logos/${offer.company.logo}",
                          jobTitle: "${offer.title!} - ${offer.company.name}",
                          reference: offer.reference!,
                          date: formatLocationDate(
                            offer.location.region!,
                            offer.location.city!,
                            offer.dateSoumission!,
                          ),
                          jobDescription: limitToLines(offer.mission!, 2, 150),
                          tags: [offer.contractType!, offer.sector!],
                          // On card tap:
                          onPressed: () async {
                            final double oldOffset = _scrollController.offset;
                            // Navigate to single offer
                            final result = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingleOfferScreen(
                                  offerId: offer.id.toString(),
                                  isSameCompany: false,
                                ),
                              ),
                            );
                            // If user changed something (applied/favorited) in SingleOfferScreen
                            if (result == true) {
                              await _refreshSavedOffres();
                              await _refreshAppliedOffers();
                              // Re-scroll to old offset if possible
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (_scrollController.hasClients) {
                                  final double maxScroll =
                                      _scrollController.position.maxScrollExtent;
                                  final double newOffset = (oldOffset > maxScroll)
                                      ? maxScroll
                                      : oldOffset;
                                  _scrollController.jumpTo(newOffset);
                                }
                              });
                            }
                          },
                          // Favorite toggling
                          isFavorite: favoriteVM.savedOffers.contains(offer.id),
                          onFavoriteToggle: () async {
                            if (favoriteVM.savedOffers.contains(offer.id)) {
                              await favoriteVM.unsaveOffer(
                                  userManager.userId!, offer.id);
                            } else {
                              await favoriteVM.saveOffer(
                                  userManager.userId!, offer.id);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  if (offreVM.isLoadingMore)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  /// Builds the header showing total offers, plus the “based on” message & filter button
  Widget _buildOffersHeader(OffreViewModel offreVM) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                      "${NumberFormat("#,###", "fr_FR").format(offreVM.total)} ",
                      style: const TextStyle(
                          fontSize: 16, fontFamily: "semi-bold", color: textColor),
                    ),
                    const TextSpan(
                      text: 'offres trouvés',
                      style: TextStyle(
                          fontSize: 16, fontFamily: "medium", color: textColor),
                    ),
                  ],
                ),
              ),
              if (based == 'profil' && !customSearch)
                const Text("Basé sur votre profil",
                    style: TextStyle(fontSize: 12, fontFamily: 'regular')),
              if (based == 'cv' && !customSearch)
                const Text("Basé sur votre cv",
                    style: TextStyle(fontSize: 12, fontFamily: 'regular')),
              if (customSearch)
                const Text("Basé sur votre recherche",
                    style: TextStyle(fontSize: 12, fontFamily: 'regular')),
            ]),
            IconButton(
              icon: Icon(Icons.filter_list_outlined, color: paragraphColor),
              onPressed: _showSortOptions,
            ),
          ]),
        ],
      ),
    );
  }

  /// Builds UI when no offers match
  Widget _buildEmptyOffers(OffreViewModel offreVM) {
    return Column(
      children: [
        _buildOffersHeader(offreVM),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(Icons.work, size: 62, color: paragraphColor),
                SizedBox(height: 20),
                Text(
                  textAlign: TextAlign.center,
                  "Désolé, nous n'avons pas trouvé d'offres qui correspondent à vos critères.",
                  style: TextStyle(
                      fontSize: 14, color: paragraphColor, fontFamily: 'medium'),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Utility: Limits text to at most [maxLines] or [maxLength] and adds "..."
// ---------------------------------------------------------------------------
String limitToLines(String text, int maxLines, int maxLength) {
  if (text.length <= maxLength) return text;

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
