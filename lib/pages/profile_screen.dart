import 'package:direct_emploi/helper/style.dart';
import 'package:direct_emploi/pages/cv_screen.dart';
import 'package:direct_emploi/pages/favourite_offers_screen.dart';
import 'package:direct_emploi/pages/offers_candidature_screen.dart';
import 'package:direct_emploi/pages/personal_info_screen.dart';
import 'package:direct_emploi/pages/recherche_screen.dart';
import 'package:direct_emploi/pages/situation_screen.dart';
import 'package:direct_emploi/viewmodels/favorite_view_model.dart';
import 'package:direct_emploi/viewmodels/offre_view_model.dart';
import 'package:direct_emploi/viewmodels/profile_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../helper/circular_icon_button.dart';
import '../helper/custom_shape.dart';
import '../helper/settings_drawers.dart';
import '../models/settings_menu_item_model.dart';
import '../services/user_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<void> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadData();
  }

  /// Fetches profile data efficiently
  Future<void> _loadData() async {
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    final favoriteViewModel = Provider.of<FavoriteViewModel>(context, listen: false);
    final offreViewModel = Provider.of<OffreViewModel>(context, listen: false);
    final userId = UserManager.instance.userId!;

    await Future.wait([
      favoriteViewModel.fetchSavedOffers(userId),
      offreViewModel.fetchAppliedOffers(userId),
      profileViewModel.fetchPersonalInfo(userId),
      profileViewModel.fetchProfileCompletion(userId),
    ]);

    if (profileViewModel.profileCompletionData?["userSituation"] == true) {
      await profileViewModel.fetchUserSituationAndCompetences(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: false,
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: FutureBuilder<void>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erreur de chargement des données'));
          }
          return _buildBody();
        },
      ),
      drawer: LeftDrawer(),
      endDrawer: RightDrawer(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(320),
      child: ClipPath(
        clipper: Customshape(),
        child: Consumer3<FavoriteViewModel, ProfileViewModel, OffreViewModel>(
          builder: (context, favoriteViewModel, profileViewModel, offViewModel, child) {
            return Container(
              height: 400,
              width: double.infinity,
              color: appColorOpacity,
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 40),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircularIconButton(
                        onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                        iconPath: Icons.menu_rounded,
                        iconColor: strokeColor,
                        iconSize: 24,
                      ),
                      CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 12.0,
                        animation: true,
                        backgroundColor: tenPercentBlack,
                        percent: (profileViewModel.profileCompletionData?['total'] ?? 0) / 100,
                        center: Text(
                          "${profileViewModel.profileCompletionData?['total'] ?? 0}%",
                          style: const TextStyle(fontFamily: "semi-bold", fontSize: 18),
                        ),
                        progressColor: appColor,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                      CircularIconButton(
                        onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
                        iconPath: Icons.settings,
                        iconColor: strokeColor,
                        iconSize: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    profileViewModel.personalInfo?.prenom?.isNotEmpty == true
                        ? "Bonjour ${profileViewModel.personalInfo!.prenom}"
                        : "Mon profil",
                    style: const TextStyle(fontSize: 18.0, fontFamily: "semi-bold"),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularIconButton(
                        badgeValue: "${offViewModel.appliedOffers.length}",
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const OffersCandidatureScreen()),
                        ),
                        iconPath: CupertinoIcons.paperclip,
                        iconColor: appColor,
                        iconSize: 24,
                      ),
                      CircularIconButton(
                        badgeValue: "${favoriteViewModel.savedOffers.length}",
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FavouriteOffersScreen()),
                        ),
                        iconPath: CupertinoIcons.heart,
                        iconColor: appColor,
                        iconSize: 24,
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<ProfileViewModel>(
      builder: (context, profileViewModel, child) {
        final data = profileViewModel.profileCompletionData ?? {};
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              _buildListTile(
                title: menuItems[0].title,
                isComplete: data['userRecherche'] ?? false,
                onTap: () => _navigateTo(const RechercheScreen()),
              ),
              _buildListTile(
                title: menuItems[1].title,
                isComplete: data['userSituation'] ?? false,
                onTap: () => _navigateTo(const SituationScreen(), refreshOnReturn: true),
              ),
              _buildListTile(
                title: menuItems[2].title,
                isComplete: data['userCv'] ?? false,
                onTap: () => _navigateTo(const CvScreen(), refreshOnReturn: true),
              ),
              _buildListTile(
                title: menuItems[3].title,
                isComplete: data['userInfo'] ?? false,
                onTap: () => _navigateTo(const PersonalInfoScreen(), refreshOnReturn: true),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateTo(Widget page, {bool refreshOnReturn = false}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page)).then((val) {
      if (refreshOnReturn && val == true) {
        _refreshProfileCompletion();
      }
    });
  }

  Future<void> _refreshProfileCompletion() async {
    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
    await viewModel.fetchProfileCompletion(UserManager.instance.userId!);
  }

  Widget _buildListTile({
    required String title,
    required bool isComplete,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: isComplete ? Colors.green : Colors.red, size: 10),
          const SizedBox(width: 10),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
      onTap: onTap,
    );
  }
}
