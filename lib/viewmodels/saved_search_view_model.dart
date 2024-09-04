import 'package:flutter/material.dart';
import '../models/saved_search_model.dart';
import '../services/api_service.dart';
import '../services/user_manager.dart';

class SavedSearchesViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<SavedSearch> _savedSearches = [];
  bool _isLoading = false;
  bool _isLoadingSaving = false;
  bool _savingSuccess = false;


  String? _error;
  String? get error => _error;

  List<SavedSearch> get savedSearches => _savedSearches;
  bool get isLoading => _isLoading;
  bool get isLoadingSaving => _isLoadingSaving;
  bool get savingSuccess => _savingSuccess;

  bool _isError = false;
  bool get isError => _isError;

  Future<void> fetchSavedSearches(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _savedSearches.clear();
      _savedSearches = await _apiService.fetchSavedSearches(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _isError = true;
      notifyListeners();
    }
  }

  Future<void> updateSavedSearch(String userId, String id, Map<String, dynamic> queryParams) async {
    _isLoading = true;
    try {
      await _apiService.updateSavedSearch(userId, id, queryParams);
      await fetchSavedSearches(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _isError = true;
      notifyListeners();
    }
  }
  Future<void> saveSearch(int userId,Map<String, dynamic> searchParams) async {
    _isLoadingSaving = true;
    _error = null;
    try {
      final response = await _apiService.saveSearch(userId, searchParams);
      _savingSuccess = true;
      _isLoadingSaving = false;
      _error = null;
    } catch (e) {
      _isLoadingSaving = false;
      _error = e.toString();
    }
    notifyListeners();
  }
  Future<void> deleteSavedSearch(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.deleteSavedSearch(id);
      _savedSearches.removeWhere((search) => search.id == id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _isError = true;
      notifyListeners();
    }
  }
}
