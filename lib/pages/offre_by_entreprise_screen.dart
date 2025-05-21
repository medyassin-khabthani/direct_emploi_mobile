import 'package:direct_emploi/helper/de_back_button.dart';
import 'package:direct_emploi/pages/single_offer_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/user_manager.dart';
import '../viewmodels/favorite_view_model.dart';
import '../viewmodels/offre_view_model.dart';
import '../helper/offre_card.dart';
import '../helper/style.dart';
import '../utils/time_formatting.dart';

class OffreByEntrepriseScreen extends StatefulWidget {
  final String entreprise;

  const OffreByEntrepriseScreen({required this.entreprise, Key? key}) : super(key: key);

  @override
  State<OffreByEntrepriseScreen> createState() => _OffreByEntrepriseScreenState();
}

class _OffreByEntrepriseScreenState extends State<OffreByEntrepriseScreen> {
  int offset = 0;
  final int limit = 10;
  final ScrollController _scrollController = ScrollController();
  bool isAtTop = true;
  UserManager userManager = UserManager.instance;
  String sortOption = "pertinence";

  @override
  void initState() {
    super.initState();

    final viewModel = Provider.of<OffreViewModel>(context, listen: false);
    viewModel.fetchOffersByEntreprise(widget.entreprise, offset, limit);

    _scrollController.addListener(_scrollListener);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !viewModel.isLoading) {
        setState(() {
          offset += limit;
        });
        viewModel.fetchMoreOffersByEntreprise(widget.entreprise, offset, limit);
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
    await viewModel.fetchOffersByEntreprise(widget.entreprise, offset, limit);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
      leading: DEBackButton(),
      title: Text(
        "Offres par ${widget.entreprise}",
        style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold'),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer2<OffreViewModel, FavoriteViewModel>(
      builder: (context, viewModel,favoriteViewModel, child) {
        if (viewModel.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (viewModel.isError || viewModel.offresEntreprise.isEmpty) {
          return Center(child: Text('Error loading job offers'));
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
                                    text: "${NumberFormat("#,###", "fr_FR").format(viewModel.total)} ",
                                    style: TextStyle(fontSize: 16, fontFamily: "semi-bold", color: textColor),
                                  ),
                                  TextSpan(
                                    text: 'offres trouvés',
                                    style: TextStyle(fontSize: 16, fontFamily: "medium", color: textColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: viewModel.offresEntreprise.map((offer) {
                      return OffreCard(
                        companyLogoPath: "https://www.directemploi.com/uploads/logos/${offer.company.logo}",
                        jobTitle: "${offer.title!} - ${offer.company.name}",
                        reference: offer.reference!,
                        date: formatLocationDate(offer.location.region!, offer.location.city!, offer.dateSoumission!),
                        jobDescription: limitToLines(offer.mission!, 2, 150),
                        tags: [offer.contractType!, offer.sector!],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SingleOfferScreen(offerId: offer.id.toString(), isSameCompany: true,)),
                          );
                        },isFavorite: favoriteViewModel.savedOffers.contains(offer.id),
                      onFavoriteToggle: () async {
                      if (favoriteViewModel.savedOffers.contains(offer.id)) {
                      await favoriteViewModel.unsaveOffer(userManager.userId!, offer.id);
                      } else {
                      await favoriteViewModel.saveOffer(userManager.userId!, offer.id);
                      }
                      },
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
