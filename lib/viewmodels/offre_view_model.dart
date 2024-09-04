import 'dart:io';

import 'package:flutter/material.dart';
import '../models/offre_model.dart';
import '../models/similar_offre_model.dart';
import '../services/api_service.dart';

class OffreViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Offre> _offres = [];
  List<Offre> _offresEntreprise = [];
  List<SimilarOffre> _similarOffres = [];
  List<Offre> _favoriteOffers = [];
  List<Offre> _candidatureOffers = [];
  int _total = 0;
  String _idSearch = "";
  String _cv = "";
  String _lm = "";
  bool _isLoading = true;
  bool _isLoadingMore = true;
  bool _isError = false;

  List<int> _appliedOffers = [];
  List<Offre> get offres => _offres;
  List<Offre> get offresEntreprise => _offresEntreprise;
  List<SimilarOffre> get similarOffres => _similarOffres;
  List<Offre> get favoriteOffers => _favoriteOffers;
  List<Offre> get candidatureOffers => _candidatureOffers;
  List<int> get appliedOffers => _appliedOffers;
  int get total => _total;
  String get idSearch => _idSearch;
  String get cv => _cv;
  String get lm => _lm;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get isError => _isError;

  Future<void> fetchOffers(int userId, Map<String, dynamic> queryParams, int offset, int limit) async {
    _isLoading = true;
    try {
      final result = await _apiService.searchOffers(userId, {
        ...queryParams,
        'offset': offset,
        'limit': limit,
      });
      _offres.clear();
      _offres.addAll(result['offers']);
      _total = result['total'];
      _idSearch = result['idSearch'];
      _isLoading = false;
      notifyListeners();

    } catch (e) {
      _isLoading = false;
      _isError = true;
      notifyListeners();
    }
  }

  Future<void> fetchOffersWithoutSave(int userId, Map<String, dynamic> queryParams, int offset, int limit) async {
    _isLoading = true;
    try {
      final result = await _apiService.searchOffersWithoutSave(userId, {
        ...queryParams,
        'offset': offset,
        'limit': limit,
      });
      _offres.clear();
      _offres.addAll(result['offers']);
      _total = result['total'];
      _isLoading = false;
      notifyListeners();

    } catch (e) {
      _isLoading = false;
      _isError = true;
      notifyListeners();
    }
  }

  Future<void> fetchMoreOffers(int userId, Map<String, dynamic> queryParams, int offset, int limit) async {
    _isLoadingMore = true;

    try {
      final result = await _apiService.searchOffers(userId, {
        ...queryParams,
        'offset': offset,
        'limit': limit,
      });
      _offres.addAll(result['offers']);
      _total = result['total'];
      _idSearch = result['idSearch'];
      _isLoadingMore = false;
      notifyListeners();

    } catch (e) {
      _isLoadingMore = false;
      _isError = true;
      notifyListeners();

    }
  }

  Future<void> fetchMoreOffersWithoutSave(int userId, Map<String, dynamic> queryParams, int offset, int limit) async {
    _isLoadingMore = true;

    try {
      final result = await _apiService.searchOffersWithoutSave(userId, {
        ...queryParams,
        'offset': offset,
        'limit': limit,
      });
      _offres.addAll(result['offers']);
      _total = result['total'];
      _isLoadingMore = false;
      notifyListeners();

    } catch (e) {
      _isLoadingMore = false;
      _isError = true;
      notifyListeners();

    }
  }

  Future<void> fetchOffersByDate(int userId, Map<String, dynamic> queryParams, int offset, int limit) async {
    _isLoading = true;
    try {
      final result = await _apiService.searchOffersByDate(userId, {
        ...queryParams,
        'offset': offset,
        'limit': limit,
      });
      _offres.clear();
      _offres.addAll(result['offers']);
      _total = result['total'];
      _idSearch = result['idSearch'];
      _isLoading = false;
      notifyListeners();

    } catch (e) {
      _isLoading = false;
      _isError = true;
      notifyListeners();
    }
  }

  Future<void> fetchOffersWithoutSaveByDate(int userId, Map<String, dynamic> queryParams, int offset, int limit) async {
    _isLoading = true;
    try {
      final result = await _apiService.searchOffersWithoutSaveByDate(userId, {
        ...queryParams,
        'offset': offset,
        'limit': limit,
      });
      _offres.clear();
      _offres.addAll(result['offers']);
      _total = result['total'];
      _isLoading = false;
      notifyListeners();

    } catch (e) {
      _isLoading = false;
      _isError = true;
      notifyListeners();
    }
  }

  Future<void> fetchMoreOffersByDate(int userId, Map<String, dynamic> queryParams, int offset, int limit) async {
    _isLoadingMore = true;

    try {
      final result = await _apiService.searchOffersByDate(userId, {
        ...queryParams,
        'offset': offset,
        'limit': limit,
      });
      _offres.addAll(result['offers']);
      _total = result['total'];
      _idSearch = result['idSearch'];
      _isLoadingMore = false;
      notifyListeners();

    } catch (e) {
      _isLoadingMore = false;
      _isError = true;
      notifyListeners();

    }
  }

  Future<void> fetchMoreOffersWithoutSaveByDate(int userId, Map<String, dynamic> queryParams, int offset, int limit) async {
    _isLoadingMore = true;

    try {
      final result = await _apiService.searchOffersWithoutSaveByDate(userId, {
        ...queryParams,
        'offset': offset,
        'limit': limit,
      });
      _offres.addAll(result['offers']);
      _total = result['total'];
      _isLoadingMore = false;
      notifyListeners();

    } catch (e) {
      _isLoadingMore = false;
      _isError = true;
      notifyListeners();

    }
  }

  Future<void> fetchOffersByEntreprise(String entreprise, int offset, int limit) async {
    _isLoading = true;
    try {
      final result = await _apiService.searchByEntreprise(entreprise, offset, limit);
      _offresEntreprise.clear();
      _offresEntreprise.addAll(result['offers']);
      _total = result['total'];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _isError = true;
      notifyListeners();
    }
  }

  Future<void> fetchMoreOffersByEntreprise(String entreprise, int offset, int limit) async {
    _isLoadingMore = true;

    try {
      final result = await _apiService.searchByEntreprise(entreprise, offset, limit);
      _offresEntreprise.addAll(result['offers']);
      _total = result['total'];
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMore = false;
      _isError = true;
      notifyListeners();
    }
  }

  Future<void> applyForOffer({
    required int userId,
    required int offerId,
    required String email,
    required String prenom,
    required String nom,
    File? cvFile,
    File? lmFile,
    int? cvId,
    required bool isCvLocal,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      print(isCvLocal);
      print("$userId, $offerId,$email,$prenom,$nom,$cvFile,$lmFile,$cvId,$isCvLocal");
      final response = await _apiService.applyForOffer(
        userId: userId,
        offerId: offerId,
        email: email,
        prenom: prenom,
        nom: nom,
        cvFile: cvFile,
        lmFile: lmFile,
        cvId: cvId,
        isCvLocal: isCvLocal,
      );
      _cv = response['cv'];
      if (response['lm'] != null){
        _lm = response['lm'];
      }

    } catch (e) {
      _isLoading = false;
      throw Exception('Failed to apply for the offer: ${e.toString()}');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchSimilarOffers(int offerId) async {
    _isLoading = true;
    try {
      _similarOffres = await _apiService.fetchSimilarOffers(offerId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _isError = true;
      notifyListeners();
    }
  }

  Future<void> applyToSimilarOffer({
    required int userId,
    required int offerId,
    required String email,
    required String prenom,
    required String nom,
    required String cv,
    String? lm,
  }) async {
    try {
      await _apiService.applyToSimilarOffer(
        userId: userId,
        offerId: offerId,
        email: email,
        prenom: prenom,
        nom: nom,
        cv: cv,
        lm: lm,
      );
      // Handle successful application if needed
    } catch (e) {
      throw Exception('Failed to apply for the similar offer: ${e.toString()}');
    }
  }

  Future<void> fetchAppliedOffers(int userId) async {
    _isLoading = true;
    try {
      _appliedOffers = await _apiService.fetchAppliedOffers(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Failed to fetch applied offers: $e');
    }
  }


  Future<void> fetchCandidatureOffers(int userId) async {
    _isLoading = true;
    try {
      _candidatureOffers = await _apiService.fetchCandidatureOffers(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _isError = true;
      notifyListeners();
    }
  }
}
