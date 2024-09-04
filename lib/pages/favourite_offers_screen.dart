import 'package:direct_emploi/pages/single_offer_screen.dart';
import 'package:direct_emploi/pages/tabbar_screen.dart';
import 'package:direct_emploi/services/user_manager.dart';
import 'package:direct_emploi/viewmodels/favorite_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/de_back_button.dart';
import '../helper/style.dart';
import '../utils/string_formatting.dart';
import '../utils/time_formatting.dart';
import '../viewmodels/offre_view_model.dart';
import '../helper/offre_card.dart';

class FavouriteOffersScreen extends StatefulWidget {
  const FavouriteOffersScreen({super.key});

  @override
  State<FavouriteOffersScreen> createState() => _FavouriteOffersScreenState();
}

class _FavouriteOffersScreenState extends State<FavouriteOffersScreen> {
  @override
  void initState() {
    super.initState();
    UserManager userManager = UserManager.instance;
    final viewModel = Provider.of<FavoriteViewModel>(context, listen: false);
    viewModel.fetchFavoriteOffers();  // Replace 1 with actual userId
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Mes offres enregistrées",
              style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold')),
          backgroundColor: Colors.white70,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: DEBackButton()
      ),
      body: Consumer2<FavoriteViewModel,OffreViewModel>(
        builder: (context, viewModel,offerViewModel, child) {
          UserManager userManager = UserManager.instance;
          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (viewModel.isError || viewModel.favoriteOffers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.bookmark,
                    size: 62,
                    color: paragraphColor,
                  ),
                  SizedBox(height: 20),
                  Text(
                    textAlign: TextAlign.center,
                    "Désolé, vous n'avez pas encore d'emploi favoris.",
                    style: TextStyle(fontSize: 14, color: paragraphColor, fontFamily: 'medium'),
                  ),
                  TextButton(onPressed: (){
                    if (mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => TabBarScreen(index: 1)),
                            (route) => false,
                      );
                    }
                  }, child: Text("Voir plus d'offres"))
                ],
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${viewModel.favoriteOffers.length} ",
                                  style: TextStyle(fontSize: 16, fontFamily: "semi-bold", color: textColor),
                                ),
                                TextSpan(
                                  text: 'offre(s) enregistrée(s)',
                                  style: TextStyle(fontSize: 16, fontFamily: "medium", color: textColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Column(
                      children: viewModel.favoriteOffers.map((offer) {
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
                              MaterialPageRoute(builder: (context) => SingleOfferScreen(offerId: offer.id.toString(), isSameCompany: false,)),
                            );
                          },
                          isFavorite: viewModel.savedOffers.contains(offer.id),
                          onFavoriteToggle: () async {
                            if (viewModel.savedOffers.contains(offer.id)) {
                              await viewModel.unsaveOffer(userManager.userId!, offer.id);
                            } else {
                              await viewModel.saveOffer(userManager.userId!, offer.id);
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
