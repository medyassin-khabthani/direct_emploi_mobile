import 'package:direct_emploi/helper/alert_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/style.dart';
import '../utils/time_formatting.dart';
import '../viewmodels/alerts_view_model.dart';
import 'alert_form.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AlertsViewModel>(context, listen: false).fetchAlerts();
    });
  }

  void _showAlertFormBottomSheet() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Set corner radius to zero
      ),
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(0.0),
          child: AlertForm(),
        );
      },
    ).then((_) {
      Provider.of<AlertsViewModel>(context, listen: false).fetchAlerts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showAlertFormBottomSheet,
        backgroundColor: appColor,
        child: Icon(Icons.add_rounded, size: 28, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: _buildAppbar(),
      body: Consumer<AlertsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (viewModel.error != null) {
            return Center(child: Text('Failed to load alerts: ${viewModel.error}'));
          } else if (viewModel.alerts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.notifications,
                    size: 62,
                    color: paragraphColor,
                  ),
                  SizedBox(height: 20),
                  Text(
                    textAlign: TextAlign.center,
                    "Désolé, vous n'avez pas d\'alerte enregistrée pour le moment.",
                    style: TextStyle(fontSize: 14, color: paragraphColor, fontFamily: 'medium'),
                  ),
                ],
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: _refreshAlerts,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: viewModel.alerts.map((alert) {
                      return AlertCard(
                        title: alert.libelle,
                        actif: alert.actif,
                        date: formatDateString(alert.dateDernierEnvoi!),
                        onTap: () {
                          // Handle card tap
                        },
                        onDelete: () async {
                          await _confirmDelete(context, viewModel, alert.id);
                        },
                        onToggleActif: () async {
                          await viewModel.toggleAlertActif(alert.id);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.white70,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(
        "Alertes mails",
        style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold'),
      ),
    );
  }

  Future<void> _refreshAlerts() async {
    print('Refreshing alerts');
    final viewModel = Provider.of<AlertsViewModel>(context, listen: false);
    await viewModel.fetchAlerts();
    print('Finished refreshing alerts');
  }

  Future<void> _confirmDelete(BuildContext context, AlertsViewModel viewModel, int alertId) async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer cette alerte ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Non'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Oui'),
          ),
        ],
      ),
    );

    if (result == true) {
      await viewModel.deleteAlert(alertId);
    }
  }
}
