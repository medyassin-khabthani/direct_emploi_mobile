import 'dart:io';

import 'package:direct_emploi/helper/de_back_button.dart';
import 'package:direct_emploi/pages/search_offers_screen.dart';
import 'package:direct_emploi/services/user_manager.dart';
import 'package:direct_emploi/viewmodels/profile_view_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../datas/de_datas.dart';
import '../helper/search_card.dart';
import '../helper/style.dart';
import '../utils/time_formatting.dart';
import '../viewmodels/saved_search_view_model.dart';

class RechercheScreen extends StatefulWidget {
  const RechercheScreen({super.key});

  @override
  State<RechercheScreen> createState() => _RechercheScreenState();
}

class _RechercheScreenState extends State<RechercheScreen> {
  String? sortOption;
  String? configId;
  UserManager userManager = UserManager.instance;
  File? _pickedFileCv;
  File? _pickedFileLm;
  String? _storedFile;
  String? _fileName1;
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  int? selectedCvId;
  String? cvFileName;

  Future<void> _refreshSavedSearches() async {
    final userId = "${UserManager.instance.userId!}";
    print('Refreshing saved searches');
    final viewModel = Provider.of<SavedSearchesViewModel>(context, listen: false);
    await viewModel.fetchSavedSearches(userId);
    print('Finished refreshing saved searches');
  }

  void _pickFileCv() async {
    try {
      final result = await showDialog<FilePickerResult>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Text("Choisir depuis le profil", style: TextStyle(fontSize: 15,fontFamily: "semi-bold"),),
                  SizedBox(height: 10,),
                  Consumer<ProfileViewModel>(
                    builder: (context, viewModel, child) {
                      return SingleChildScrollView(
                        child: ListBody(
                          children: viewModel.userCvs!
                              .map((cv) => ListTile(
                              title: Text(cv.nomFichierCvOriginal),
                              onTap: () async {
                                setState(() {
                                  _fileName1 = cv.nomFichierCvOriginal;
                                  selectedCvId = cv.id;
                                });
                                Navigator.of(context).pop();

                                await viewModel.extractCvText(selectedCvId!,configId!).then((_) {
                                  sortOption = 'cv';
                                });

                                viewModel.getUserConfiguration().then((_) {
                                  if (viewModel.userConfiguration != null) {
                                    setState(() {
                                      //sortOption = viewModel.userConfiguration!.configuration.based ?? 'none';
                                      configId = viewModel.userConfiguration!.id;
                                      cvFileName = viewModel.userConfiguration!.configuration.cvFile;
                                    });
                                  }
                                });
                              }
                          ))
                              .toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        setState(() {
          _pickedFileCv = File(file.path!);
          _fileName1 = file.name;
        });
      }
    } on PlatformException catch (e) {
      _logException('Unsupported operation: ${e.toString()}');
    } catch (e) {
      _logException(e.toString());
    }
  }
  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
        _refreshSavedSearches();
      final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
      viewModel.fetchUserCvs(userManager.userId!);

      viewModel.getUserConfiguration().then((_) {
        if (viewModel.userConfiguration != null) {
          setState(() {
            sortOption = viewModel.userConfiguration!.configuration.based ?? 'none';
            configId = viewModel.userConfiguration!.id;
            if (viewModel.userConfiguration!.configuration.based == 'cv'){
              cvFileName = viewModel.userConfiguration!.configuration.cvFile;
            }
          });
        }
        if (viewModel.profileCompletionData?['userSituation'] != false) {
          viewModel.fetchUserSituationAndCompetences(userManager.userId!);
        }
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0,
        centerTitle: true,
        leading: DEBackButton(),
        title: Text(
          "Ma recherche",
          style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Consumer<ProfileViewModel>(
              builder: (context, profileViewModel, child) {
                if (profileViewModel.isLoading || sortOption == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Recommandation des listes d'emploi",
                          style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold')),
                      Divider(),
                      Opacity(
                        opacity: profileViewModel.userCvs!.isEmpty || profileViewModel.userCvs == null ? 0.6:1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RadioListTile<String>(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Adapté à mon CV',
                                  style: TextStyle(fontFamily: "regular", fontSize: 14)),
                              value: 'cv',
                              groupValue: sortOption,
                              onChanged: (String? value) {
                                if(profileViewModel.userCvs!.isEmpty || profileViewModel.userCvs == null){
                                  return;
                                }else{
                                  _pickFileCv();
                                }
                              },
                            ),
                            cvFileName != null ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Fichier: ",style: TextStyle(fontSize: 12,fontFamily: 'medium'),),
                                  Text(cvFileName!,style: TextStyle(fontSize: 12,fontFamily: 'regular'))
                              ],),
                            ) : SizedBox(),
                            if (profileViewModel.userCvs!.isEmpty || profileViewModel.userCvs == null)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  "Vous devez deposer au moins un cv.",
                                  style: TextStyle(fontSize: 12,fontFamily:'regular'),
                                ),
                              ),
                  
                          ],
                        ),
                      ),
                      Opacity(
                        opacity: profileViewModel.profileCompletionData?["userSituation"] == false ? 0.6 : 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RadioListTile<String>(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Adapté à mon profil',
                                style: TextStyle(fontFamily: "regular", fontSize: 14),
                              ),
                              value: 'profil',
                              groupValue: sortOption,
                              onChanged: (String? value) {
                                if (profileViewModel.profileCompletionData?["userSituation"] == false) {
                                  return;
                                } else {
                                  setState(() {
                                    sortOption = value!;
                                  });
                                  profileViewModel.updateUserConfiguration(configId!, {
                                    "based": "profil",
                                    "q": profileViewModel.userSituation!.posteActuel,
                                    "localisation": regions[profileViewModel.userSituation!.idMobilite]
                                  });
                                }
                              },
                            ),
                            if (profileViewModel.profileCompletionData?["userSituation"] == false)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  "Vous devez remplir votre situation.",
                                  style: TextStyle(fontSize: 12,fontFamily:'regular'),
                                ),
                              ),
                          ],
                        ),
                      ),
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Aucune adaptation',
                          style: TextStyle(fontFamily: "regular", fontSize: 14),
                        ),
                        value: 'none',
                        groupValue: sortOption,
                        onChanged: (String? value) {
                          setState(() {
                            sortOption = value!;
                          });
                          profileViewModel.updateUserConfiguration(configId!, {"based": "none"});
                        },
                      ),
                      SizedBox(height: 20,),
                      Text("Historique de recherche",
                          style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold')),
                      Divider(),
                      Consumer<SavedSearchesViewModel>(
                        builder: (context, viewModel, child) {
                          if (viewModel.isLoading) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (viewModel.isLoading && viewModel.savedSearches.isEmpty) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (viewModel.savedSearches.isEmpty && !viewModel.isLoading) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.search_off_rounded,
                                    size: 62,
                                    color: paragraphColor,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    textAlign: TextAlign.center,
                                    "Aucune recherche n'est trouvée pour le moment.",
                                    style: TextStyle(fontSize: 14, color: paragraphColor, fontFamily: 'medium'),
                                  ),
                                ],
                              ),
                            );
                          }

                          return RefreshIndicator(
                            onRefresh: _refreshSavedSearches,
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(
                                children: viewModel.savedSearches.map((savedSearch) {
                                  return SearchCard(
                                    query: savedSearch.searchParams.q,
                                    localisation: savedSearch.searchParams.localisation,
                                    contrat: savedSearch.searchParams.contrat,
                                    date: formatDateString(savedSearch.savedAt),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SearchOffersScreen(
                                            query: savedSearch.searchParams.q!,
                                            localisation: savedSearch.searchParams.localisation!,
                                            selectedContrat: savedSearch.searchParams.contrat!,
                                          ),
                                        ),
                                      ).then((val) {
                                        if (val == true) {
                                          _refreshSavedSearches();
                                        }
                                      });
                                    },
                                    onDelete: () async {
                                      bool confirmDelete = await _showDeleteConfirmationDialog(context);
                                      if (confirmDelete) {
                                        await viewModel.deleteSavedSearch(savedSearch.id);
                                      }
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Voulez-vous vraiment supprimer cette recherche enregistrée ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    ) ?? false;
  }

}
