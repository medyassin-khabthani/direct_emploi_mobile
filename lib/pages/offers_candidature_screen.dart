import 'package:direct_emploi/helper/de_back_button.dart';
import 'package:direct_emploi/pages/favourite_offers_screen.dart';
import 'package:direct_emploi/pages/single_offer_screen.dart';
import 'package:direct_emploi/pages/tabbar_screen.dart';
import 'package:direct_emploi/viewmodels/favorite_view_model.dart';
import 'package:direct_emploi/viewmodels/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/offre_card.dart';
import '../helper/style.dart';
import '../services/user_manager.dart';
import '../utils/string_formatting.dart';
import '../utils/time_formatting.dart';
import '../viewmodels/offre_view_model.dart';
class OffersCandidatureScreen extends StatefulWidget {
  const OffersCandidatureScreen({super.key});

  @override
  State<OffersCandidatureScreen> createState() => _OffersCandidatureScreenState();
}


class _OffersCandidatureScreenState extends State<OffersCandidatureScreen> {

  @override
  void initState(){
    super.initState();
    UserManager userManager = UserManager.instance;
    final viewModel = Provider.of<OffreViewModel>(context, listen: false);
    viewModel.fetchCandidatureOffers(userManager.userId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes candidatures",
            style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold')),
        backgroundColor: Colors.white70,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: DEBackButton()
      ),
      body: SafeArea(
        child: Consumer2<OffreViewModel,FavoriteViewModel>(
          builder:(context, offerViewModel,favoriteViewModel,child){
            UserManager userManager = UserManager.instance;
            if (offerViewModel.isLoading){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (offerViewModel.candidatureOffers.isEmpty){
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
                      "Désolé, vous n'avez pas encore déposé de candidatures.",
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
            }
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
                                    text: "${offerViewModel.candidatureOffers.length} ",
                                    style: TextStyle(fontSize: 16, fontFamily: "semi-bold", color: textColor),
                                  ),
                                  TextSpan(
                                    text: 'candidature(s) enregistrée(s)',
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
                        children: offerViewModel.candidatureOffers.map((offer) {
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
                            isFavorite: favoriteViewModel.savedOffers.contains(offer.id),
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
                    ],
                  ),
              ),
            );
          }
        ),
      ),
    );
  }
}
