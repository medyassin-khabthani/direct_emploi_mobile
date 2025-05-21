import 'dart:io';
import 'package:direct_emploi/pages/pdf_view_screen.dart';
import 'package:direct_emploi/pages/tabbar_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:direct_emploi/helper/de_back_button.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../helper/style.dart';
import '../utils/time_formatting.dart';
import '../viewmodels/profile_view_model.dart';
import '../models/cv_model.dart';

class CvScreen extends StatefulWidget {
  const CvScreen({super.key});

  @override
  State<CvScreen> createState() => _CvScreenState();
}

class _CvScreenState extends State<CvScreen> {
  String? based;
  String? configId;

  @override
  void initState() {
    super.initState();
    final profileViewModel =
    Provider.of<ProfileViewModel>(context, listen: false);
    profileViewModel.fetchUserCvs(profileViewModel.userManager.userId!);
    profileViewModel.getUserConfiguration().then((_) {
      if (profileViewModel.userConfiguration != null) {
        setState(() {
          based =
              profileViewModel.userConfiguration!.configuration.based ?? 'none';
          configId = profileViewModel.userConfiguration!.id;
        });
      }
    });
  }

  void _showUploadCvBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return UploadCvBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUploadCvBottomSheet(context),
        backgroundColor: appColor,
        child: const Icon(Icons.add_rounded, size: 28, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.white70,
      elevation: 0,
      centerTitle: true,
      leading: DEBackButton(),
      title: const Text(
        "Mes CV",
        style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold'),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<ProfileViewModel>(
      builder: (context, profileViewModel, child) {
        if (profileViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (profileViewModel.error != null) {
          return const Center(child: Text('Failed to load data'));
        }

        if (profileViewModel.userCvs == null ||
            profileViewModel.userCvs!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(
                  Icons.file_copy,
                  size: 62,
                  color: paragraphColor,
                ),
                SizedBox(height: 20),
                Text(
                  textAlign: TextAlign.center,
                  "Désolé, vous n'avez pas encore déposé de CV.",
                  style: TextStyle(
                      fontSize: 14, color: paragraphColor, fontFamily: 'medium'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: profileViewModel.userCvs!.length,
          itemBuilder: (context, index) {
            final cv = profileViewModel.userCvs![index];
            final cvUrl =
                'https://www.directemploi.com/uploads_test/cv_cand_save/${cv.nomFichierCvStockage}';
            return Opacity(
              opacity: cv.isVisible == 1 ? 1.0 : 0.5,
              child: InkWell(
                hoverColor: Colors.white,
                focusColor: Colors.white,
                highlightColor: Colors.white,
                splashColor: Colors.white,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewScreen(
                          pdfUrl: cvUrl, pdfTitle: cv.nomFichierCvOriginal),
                    ),
                  );
                },
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: strokeColor, width: 1),
                  ),
                  margin: const EdgeInsets.all(10.0),
                  child: ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15.0),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${formatDateString(cv.dateCreation)}',
                          style: const TextStyle(
                            color: paragraphColor,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                    subtitle: Text(
                      cv.nomFichierCvOriginal,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'toggle') {
                          await profileViewModel.toggleCvVisibility(cv.id);
                        } else if (value == 'delete') {
                          await _confirmDelete(context, profileViewModel, cv.id);
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'toggle',
                          child: Text(cv.isVisible == 1
                              ? 'Rendre non visible'
                              : 'Rendre visible'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Supprimer'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, ProfileViewModel viewModel, int cvId) async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Are you sure you want to delete this CV?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (result == true) {
      await viewModel.deleteCv(cvId).then((_) {
        if (based == 'cv') {
          viewModel.updateUserConfiguration(configId!, {"based": "none"});
        }
      });
    }
  }
}

class UploadCvBottomSheet extends StatefulWidget {
  @override
  _UploadCvBottomSheetState createState() => _UploadCvBottomSheetState();
}

class _UploadCvBottomSheetState extends State<UploadCvBottomSheet> {
  File? selectedFile;
  String? selectedFileName;
  int isVisible = 0;
  int isAnonym = 1;

  // <-- Added: track picking file
  bool _isPickingFile = false;

  @override
  Widget build(BuildContext context) {
    final profileViewModel =
    Provider.of<ProfileViewModel>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.55, // Adjust height as needed
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Ajouter un CV',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // First loading: while picking file
          _isPickingFile
              ? const CircularProgressIndicator() // spinner during file pick
              : OutlinedButton.icon(
            icon: const Icon(Icons.file_upload, color: appColor),
            label: Text(
              selectedFileName != null
                  ? 'Modifier le fichier'
                  : 'Sélectionner un fichier',
              style: const TextStyle(color: appColor),
            ),
            onPressed: () async {
              setState(() {
                _isPickingFile = true; // start picking
              });
              final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf', 'doc', 'docx']);

              setState(() {
                _isPickingFile = false; // finished picking
              });

              if (result != null && result.files.isNotEmpty) {
                final file = File(result.files.single.path!);

                // <-- Added: Validate file size (<= 4 MB)
                if (file.lengthSync() > 4 * 1024 * 1024) {
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Le fichier sélectionné dépasse 4 MB. Veuillez choisir un fichier plus léger.',
                      ),
                    ),
                  );
                } else {
                  setState(() {
                    selectedFile = file;
                    selectedFileName = result.files.single.name;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Fichier sélectionné avec succès')),
                  );
                }
              }
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: appColor),
            ),
          ),

          if (selectedFileName != null) ...[
            const SizedBox(height: 10),
            Text(
              '$selectedFileName',
              style: const TextStyle(color: paragraphColor),
            ),
          ],

          const SizedBox(height: 30),
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rendre mon CV visible',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Text('Votre CV sera consultable par les recruteurs',
                        style: TextStyle(
                          fontSize: 12,
                          color: paragraphColor,
                        ))
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ToggleSwitch(
                customWidths: const [60.0, 60.0],
                cornerRadius: 10.0,
                activeBgColors: const [
                  [Colors.lightBlueAccent],
                  [Colors.redAccent]
                ],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                totalSwitches: 2,
                labels: const ['Oui', 'Non'],
                initialLabelIndex: isVisible,
                onToggle: (index) {
                  setState(() {
                    isVisible = index!;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rendre mon CV anonyme',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Les recruteurs pourront télécharger votre CV, veillez à utiliser un CV anonyme',
                      style: TextStyle(
                        fontSize: 12,
                        color: paragraphColor,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ToggleSwitch(
                customWidths: const [60.0, 60.0],
                cornerRadius: 10.0,
                activeBgColors: const [
                  [Colors.lightBlueAccent],
                  [Colors.redAccent]
                ],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                totalSwitches: 2,
                labels: const ['Oui', 'Non'],
                initialLabelIndex: isAnonym,
                onToggle: (index) {
                  setState(() {
                    isAnonym = index!;
                  });
                },
              ),
            ],
          ),
          const Spacer(),

          // Second loading: "Télécharger le CV"
          Consumer<ProfileViewModel>(
            builder: (context, vm, child) {
              return ElevatedButton(
                onPressed: (selectedFile == null || vm.isLoadingUpdate)
                    ? null
                    : () async {
                  await vm.uploadCv(selectedFile!, isVisible, isAnonym);
                  if (!vm.isError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('CV ajouté avec succès')),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Une erreur est survenue lors de l\'ajout de CV',
                        ),
                      ),
                    );
                  }
                },
                style: appButton(),
                child: vm.isLoadingUpdate
                    ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : const Text('Télécharger le CV'),
              );
            },
          ),
        ],
      ),
    );
  }
}
