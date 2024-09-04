import 'package:flutter/material.dart';
import '../models/offre_model.dart';
import '../services/api_service.dart';
import '../services/user_manager.dart';

class FavoriteViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  UserManager userManager = UserManager.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isError = false;
  bool get isError => _isError;

  List<Offre> _favoriteOffers = [];
  List<Offre> get favoriteOffers => _favoriteOffers;

  List<int> _savedOffers = [];
  List<int> get savedOffers => _savedOffers;

  Future<void> fetchSavedOffers(int userId) async {
    _isLoading = true;
    _isError = false;

    try {
      _savedOffers = await _apiService.fetchSavedOffers(userId);
      print(_savedOffers);
      _isLoading = false;
      _isError = false;
    } catch (e) {
      _isLoading = false;
      _isError = true;
    }
    notifyListeners();
  }

  Future<void> saveOffer(int userId, int offerId) async {
    try {
      await _apiService.saveOffer(userId, offerId);
      await fetchSavedOffers(userId);
    } catch (e) {
      _isError = true;
      notifyListeners();
    }
  }

  Future<void> unsaveOffer(int userId, int offerId) async {
    try {
      await _apiService.unsaveOffer(userId, offerId);
      await fetchSavedOffers(userId);
      await fetchFavoriteOffers();
    } catch (e) {
      _isError = true;
      notifyListeners();
    }
  }
  Future<void> fetchFavoriteOffers() async {
    _isLoading = true;
    try {
      _favoriteOffers = await _apiService.fetchFavoriteOffers(_savedOffers);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _isError = true;
      notifyListeners();
    }
  }
}
