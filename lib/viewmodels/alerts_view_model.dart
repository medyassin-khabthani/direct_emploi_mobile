import 'package:direct_emploi/services/user_manager.dart';
import 'package:flutter/material.dart';
import '../models/alert_model.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertsViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Alert> _alerts = [];
  bool _isLoading = false;
  String? _error;

  List<Alert> get alerts => _alerts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  UserManager userManager = UserManager.instance;
  Future<void> fetchAlerts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userId = userManager.userId!;
      _alerts = await _apiService.fetchUserAlerts(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<bool> createAlert(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    data["userId"] = userManager.userId!;

    bool success = await _apiService.registerStep3(data);
    fetchAlerts();
    _isLoading = false;
    notifyListeners();

    return success;
  }

  Future<void> toggleAlertActif(int alertId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.toggleAlertActif(alertId);
      await fetchAlerts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> deleteAlert(int alertId) async {
    try {
      await _apiService.deleteAlert(alertId);
      _alerts.removeWhere((alert) => alert.id == alertId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

}
