import 'package:direct_emploi/helper/de_back_button.dart';
import 'package:direct_emploi/pages/offer_submission_screen.dart';
import 'package:direct_emploi/pages/offre_by_entreprise_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/horizontal_scrollable_menu.dart';
import '../helper/style.dart';
import '../helper/tags.dart';
import 'package:share_plus/share_plus.dart';

import 'package:flutter_html/flutter_html.dart';

import '../services/user_manager.dart';
import '../utils/time_formatting.dart';
import '../viewmodels/favorite_view_model.dart';
import '../viewmodels/offre_details_view_model.dart';

class SingleOfferScreen extends StatefulWidget {
  final String offerId;
  final bool isSameCompany;

  const SingleOfferScreen({super.key, required this.offerId, required this.isSameCompany});

  @override
  State<SingleOfferScreen> createState() => _SingleOfferScreenState();
}

class _SingleOfferScreenState extends State<SingleOfferScreen> {
  int selectedIndex = 0;
  UserManager userManager = UserManager.instance;
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<OffreDetailsViewModel>(
        context, listen: false);
    viewModel.fetchOfferDetails(widget.offerId);
    final favoriteViewModel = Provider.of<FavoriteViewModel>(context, listen: false);
    favoriteViewModel.fetchSavedOffers(userManager.userId!);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading:DEBackButton(),
      title: Consumer<OffreDetailsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Text('Chargement...',style: TextStyle(
                fontSize: 14, color: textColor, fontFamily: 'semi-bold'),);
          } else if (viewModel.isError) {
            return Text('Erreur');
          } else {
            return Text(
              viewModel.offer?.title ?? '',
              style: TextStyle(
                  fontSize: 14, color: textColor, fontFamily: 'semi-bold'),
            );
          }
        },
      ),
      actions: [
        Consumer<FavoriteViewModel>(
          builder: (context, favoriteViewModel, child) {
            final viewModel = Provider.of<OffreDetailsViewModel>(context, listen: false);
            final isFavorite = favoriteViewModel.savedOffers.contains(int.parse(widget.offerId));
            return IconButton(
              onPressed: () async {
                if (isFavorite) {
                  await favoriteViewModel.unsaveOffer(userManager.userId!, int.parse(widget.offerId));
                } else {
                  await favoriteViewModel.saveOffer(userManager.userId!, int.parse(widget.offerId));
                }
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_outline,
                color: isFavorite ? appColor : null,
              ),
            );
          },
        ),
        IconButton(
          onPressed: () {
            Share.share(
                'Veuillez voir cette offre https://www.directemploi.com/candidatOffre/${widget
                    .offerId}');
          },
          icon: Icon(Icons.share),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Consumer<OffreDetailsViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (viewModel.isError) {
          return Center(child: Text('Erreur lors du chargement des offres'));
        } else if (viewModel.offer == null) {
          return Center(child: Text('Aucun détail d\'offre disponible'));
        } else {
          final offer = viewModel.offer!;
          return Container(
            height: double.infinity,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.network(
                                "https://www.directemploi.com/uploads/logos/${offer.company.logo}",
                                height: 80.0,
                                alignment: Alignment.center,
                                filterQuality: FilterQuality.high,
                              ),
                              SizedBox(height: 10,),
                              Text(
                                formatDate(offer.dateSoumission!),
                                style: TextStyle(
                                    fontSize: 12, color: paragraphColor),
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      offer.title!,
                                      style: TextStyle(fontSize: 16,
                                          color: textColor,
                                          fontFamily: 'semi-bold'),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  if (offer.isHandicap == true)
                                    Row(
                                      children: [
                                        SizedBox(width: 5,),
                                        Text("Handicap",style: TextStyle(fontSize: 15),)
                                      ],
                                    ),


                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Wrap(
                                spacing: 8.0,
                                children: [
                                  Tags(tag: offer.contractType!),
                                  Tags(tag: offer.sector!),
                                  Tags(tag: "${offer.location.region!} ${offer.location.department!} ${offer.location.city!}"),

                                ]
                              ),

                              if(offer.dureeContrat != null && offer.dureeContrat != "" )
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 15.0),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                      Text("Durée de contrat:",style: TextStyle(fontFamily: 'semi-bold'),),
                                      SizedBox(width: 10,),
                                      Text(offer.dureeContrat!)
                                      ],
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 5),
                              TextButton(
                                onPressed: () {
                                  if(widget.isSameCompany){
                                    Navigator.pop(context,true);
                                  }else{
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => OffreByEntrepriseScreen(entreprise: offer.company.name!,)),
                                    );
                                  }

                                },
                                child: Text("Découvrir l'entreprise, toutes les offres"),
                              )
                            ],
                          ),
                        ),
                      ),
                      HorizontalScrollableMenu(
                        titles: ["Description de l'offre", "Profil recherché", "Présentation de l'entreprise"],
                        contents: [
                          Html(
                            data:offer.mission!),
                          Html(
                              data:offer.profil!),
                          Html(
                              data:offer.company.presentationSociete!),
                        ],
                        onTitleClick: (index) =>
                            setState(() {
                              selectedIndex = index;
                            }),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 100.0),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: [
                            Html(
                                data:offer.mission!),
                            Html(
                                data:offer.profil!),
                            Html(
                                data:offer.company.presentationSociete!),
                          ][selectedIndex],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20.0, // Adjust positioning as needed
                  left: 0.0, // Start from left edge (full width)
                  right: 0.0, // Extend to right edge (full width)
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: FloatingActionButton(
                            elevation: 2,
                            backgroundColor: appColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust corner radius
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => OfferSubmissionScreen(offre: viewModel.offer!,)),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              // Adjust padding
                              child: Text(
                                "Postuler maintenant", // Replace with your text
                                style: TextStyle(
                                  color: Colors.white, // Adjust text color
                                  fontSize: 16.0, // Adjust font size
                                ),
                              ),
                            ), // Adjust border
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
