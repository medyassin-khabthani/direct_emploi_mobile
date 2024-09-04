import 'package:direct_emploi/helper/style.dart';
import 'package:direct_emploi/pages/tabbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/similar_offre_card.dart';
import '../models/similar_offre_model.dart';
import '../services/user_manager.dart';
import '../utils/string_formatting.dart';
import '../utils/time_formatting.dart';
import '../viewmodels/favorite_view_model.dart';
import '../viewmodels/offre_view_model.dart';

class SimilarOfferScreen extends StatefulWidget {
  final int offerId;
  final int userId;
  final String nom;
  final String prenom;
  final String email;
  final String cv;
  final String? lm;

  const SimilarOfferScreen({
    Key? key,
    required this.offerId,
    required this.userId,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.cv,
    this.lm,
  }) : super(key: key);

  @override
  _SimilarOfferScreenState createState() => _SimilarOfferScreenState();
}

class _SimilarOfferScreenState extends State<SimilarOfferScreen> {
  bool allApplied = false;
  UserManager userManager = UserManager.instance;

  @override
  void initState() {
    super.initState();
    final offreViewModel = Provider.of<OffreViewModel>(context, listen: false);
    offreViewModel.fetchSimilarOffers(widget.offerId).then((value) {
      if (offreViewModel.similarOffres.isEmpty) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => TabBarScreen(index: 1)),
                (route) => false,
          );
        }
      }
    });

    offreViewModel.fetchAppliedOffers(widget.userId);  // Fetch applied offers
  }

  Future<void> _applyToSimilarOffer(SimilarOffre offer) async {
    final offreViewModel = Provider.of<OffreViewModel>(context, listen: false);
    try {
      await offreViewModel.applyToSimilarOffer(
        userId: widget.userId,
        offerId: offer.id,
        email: widget.email,
        prenom: widget.prenom,
        nom: widget.nom,
        cv: widget.cv,
        lm: widget.lm,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Votre postulation a été soumise avec succès.')),
      );
      setState(() {
        offer.applied = true;
        allApplied = offreViewModel.similarOffres.every((offer) => offer.applied);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de postulation: $e')),
      );
    }
  }

  void _applyToAllOffers() async {
    final offreViewModel = Provider.of<OffreViewModel>(context, listen: false);
    for (var offer in offreViewModel.similarOffres) {
      if (!offer.applied) {
        await _applyToSimilarOffer(offer);
      }
    }
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => TabBarScreen(index: 1)),
            (route) => false,
      );
    }
  }

  void _skipOffers() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => TabBarScreen(index: 1)),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Des offres similaires",
          style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold'),
        ),
        actions: [
          TextButton(
            onPressed: _skipOffers,
            child: Text("Passer", style: TextStyle(color: paragraphColor)),
          ),
        ],
      ),
      body: Consumer2<OffreViewModel, FavoriteViewModel>(
        builder: (context, offreViewModel, favoriteViewModel, child) {
          if (offreViewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: offreViewModel.similarOffres.length,
            itemBuilder: (context, index) {
              final offer = offreViewModel.similarOffres[index];
              bool isApplied = offreViewModel.appliedOffers.contains(offer.id);
              return Opacity(
                opacity: isApplied ? 0.6 : 1.0,
                child: SimilarOffreCard(
                  companyLogoPath: "https://www.directemploi.com/uploads/logos/${offer.logo}",
                  jobTitle: "${offer.title} - ${offer.companyName}",
                  reference: offer.reference,
                  date: formatLocationDate("", offer.ville, offer.dateSoumission),
                  jobDescription: limitToLines(offer.mission, 2, 150),
                  tags: [offer.contractType],
                  onPressed: () {},
                  isFavorite: favoriteViewModel.savedOffers.contains(offer.id),
                  onFavoriteToggle: () async {
                    if (favoriteViewModel.savedOffers.contains(offer.id)) {
                      await favoriteViewModel.unsaveOffer(userManager.userId!, offer.id);
                    } else {
                      await favoriteViewModel.saveOffer(userManager.userId!, offer.id);
                    }
                  },
                  applyButton: ElevatedButton(
                    style: appButton(),
                    onPressed:offreViewModel.isLoading ? null : offer.applied ? null : () => _applyToSimilarOffer(offer),
                    child:offreViewModel.isLoading
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : Text('Postuler à cette offre'),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _applyToAllOffers,
        child: Icon(Icons.send),
        backgroundColor: appColor,
      ),
    );
  }
}
