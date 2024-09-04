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
  UserManager userManager = UserManager.instance;

  @override
  void initState() {
  super.initState();
  }
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profileViewModel =
      Provider.of<ProfileViewModel>(context, listen: false);

      await Provider.of<FavoriteViewModel>(context, listen: false)
          .fetchSavedOffers(userManager.userId!);
      await Provider.of<OffreViewModel>(context, listen: false)
          .fetchAppliedOffers(userManager.userId!);
      await profileViewModel.fetchPersonalInfo(userManager.userId!);

      await profileViewModel.fetchProfileCompletion(userManager.userId!);

      if (profileViewModel.profileCompletionData?["userSituation"] == true) {
        profileViewModel.fetchUserSituationAndCompetences(userManager.userId!);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      backgroundColor: const Color(0xFFffffff),
      body: _buildBody(),
      drawer: LeftDrawer(),
      endDrawer: RightDrawer(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: new Container(),
      actions: <Widget>[
        new Container(),
      ],
      toolbarHeight: 320,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      flexibleSpace: ClipPath(
        clipper: Customshape(),
        child: Consumer3<FavoriteViewModel, ProfileViewModel,OffreViewModel>(
          builder: (context, favoriteViewModel, profileViewModel,offViewModel, child) {
            if (favoriteViewModel.isLoading || profileViewModel.isLoading || offViewModel.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
              height: 400,
              width: MediaQuery.of(context).size.width,
              color: appColorOpacity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 40),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircularIconButton(
                          onPressed: () {
                            _scaffoldKey.currentState!.openDrawer();
                          },
                          iconPath: Icons.menu_rounded,
                          iconColor: strokeColor,
                          iconSize: 24,
                        ),
                        CircularPercentIndicator(
                          radius: 60.0,
                          lineWidth: 12.0,
                          animation: true,
                          backgroundColor: tenPercentBlack,
                          percent:
                          profileViewModel.profileCompletionData?['total'] != null ?
                          (profileViewModel.profileCompletionData?['total'] /
                                      100):
                                  0.0,
                          center: Text(
                            "${profileViewModel.profileCompletionData?['total'] ?? 0}%",
                            style: TextStyle(
                                fontFamily: "semi-bold", fontSize: 18),
                          ),
                          progressColor: appColor,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                        CircularIconButton(
                          onPressed: () {
                            _scaffoldKey.currentState!.openEndDrawer();
                          },
                          iconPath: Icons.settings,
                          iconColor: strokeColor,
                          iconSize: 24,
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                     Text(
                       profileViewModel.personalInfo?.prenom != '' && profileViewModel.personalInfo?.prenom != null ? "Bonjour ${profileViewModel.personalInfo!.prenom}" :"Mon profil" ,
                      style: TextStyle(fontSize: 18.0, fontFamily: "semi-bold"),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularIconButton(
                          badgeValue: "${offViewModel.appliedOffers.length}",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OffersCandidatureScreen()),
                            );
                          },
                          iconPath: CupertinoIcons.paperclip,
                          iconColor: appColor,
                          iconSize: 24,
                        ),
                        CircularIconButton(
                          badgeValue: "${favoriteViewModel.savedOffers.length}",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FavouriteOffersScreen()),
                            );
                          },
                          iconPath: CupertinoIcons.heart,
                          iconColor: appColor,
                          iconSize: 24,
                        ),
                      ],
                    )
                  ],
                ),
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
        if (profileViewModel.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (profileViewModel.isError) {
          return Center(child: CircularProgressIndicator());
        } else {
          final data = profileViewModel.profileCompletionData;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                _buildListTile(
                  title: menuItems[0].title,
                  isComplete: data?['userRecherche'] ?? false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RechercheScreen()),
                    );
                  },
                ),
                _buildListTile(
                  title: menuItems[1].title,
                  isComplete: data?['userSituation'] ?? false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SituationScreen()),
                    ).then((val) {
                      if (val == true) {
                        _refreshProfilCompletion();
                      }
                    });
                  },
                ),
                _buildListTile(
                  title: menuItems[2].title,
                  isComplete: data?['userCv'] ?? false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CvScreen()),
                    ).then((val) {
                      if (val == true) {
                        _refreshProfilCompletion();
                      }
                    });
                  },
                ),
                _buildListTile(
                  title: menuItems[3].title,
                  isComplete: data?['userInfo'] ?? false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PersonalInfoScreen()),
                    ).then((val) {
                      if (val == true) {
                        _refreshProfilCompletion();
                      }
                    });
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<void> _refreshProfilCompletion() async {
    print('Refreshing profile completion');
    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
    await viewModel.fetchProfileCompletion(userManager.userId!);
    print('Finished refreshing profile completion');
  }

  Widget _buildListTile({
    required String title,
    required bool isComplete,
    required Function() onTap,
  }) {
    return ListTile(
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            color: isComplete ? Colors.green : Colors.red,
            size: 10,
          ),
          SizedBox(width: 10),
          Icon(Icons.chevron_right_rounded),
        ],
      ),
      onTap: onTap,
    );
  }
}
