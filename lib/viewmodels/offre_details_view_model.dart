// viewmodels/offer_details_viewmodel.dart

import 'package:flutter/material.dart';
import '../models/offre_model.dart';
import '../services/api_service.dart';

class OffreDetailsViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  Offre? _offer;
  bool _isLoading = false;
  bool _isError = false;

  Offre? get offer => _offer;
  bool get isLoading => _isLoading;
  bool get isError => _isError;

  Future<void> fetchOfferDetails(String id) async {
    _isLoading = true;
    _isError = false;

    try {
      _offer = await _apiService.fetchOfferDetails(id);
    } catch (e) {
      _isError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
