import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DataFetchingViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  Map<int, String> _secteurActivites = {};
  Map<int, String> _listePays = {};
  Map<int, String> _metiers = {};
  Map<int, String> _metiersAlert = {};
  Map<int, String> _departements = {};
  Map<int, String> _etablissements = {};
  Map<int, String> _fourchettes = {};
  Map<int, String> _situationActivites = {};
  Map<int, String> _situationExperiences = {};
  Map<int, String> _disponibilites = {};
  Map<int, String> _mobilites = {};
  Map<int, String> _langues = {};
  Map<int, String> _niveaux = {};
  List<String> _jobTitles = [];

  bool _isLoading = false;
  bool _isLoadingMetier = false;
  bool _isLoadingMetierAlert = false;
  bool _isLoadingDepartements = false;
  bool _isLoadingEtablissement = false;
  bool _isLoadingSecteur = false;
  bool _isLoadingPays = false;
  bool _isLoadingFourchette = false;
  bool _isLoadingSituationActivites = false;
  bool _isLoadingSituationExperiences = false;
  bool _isLoadingDisponibilite = false;
  bool _isLoadingMobilite = false;
  bool _isLoadingLangues = false;
  bool _isLoadingNiveaux = false;
  bool _isLoadingJobs = false;
  String? _error;


  Map<int, String> get metiers => _metiers;
  Map<int, String> get metiersAlert => _metiersAlert;
  Map<int, String> get departements => _departements;
  Map<int, String> get etablissements => _etablissements;
  Map<int, String> get fourchettes => _fourchettes;
  Map<int, String> get situationExperiences => _situationExperiences;
  Map<int, String> get disponibilites => _disponibilites;
  Map<int, String> get mobilites => _mobilites;
  Map<int, String> get niveaux => _niveaux;
  List<String> get jobTitles => _jobTitles;

  Map<int, String> get secteurActivites => _secteurActivites;
  Map<int, String> get situationActivites => _situationActivites;
  Map<int, String> get listePays => _listePays;
  Map<int, String> get langues => _langues;
  bool get isLoadingSecteur => _isLoadingSecteur;
  bool get isLoadingMetier => _isLoadingMetier;
  bool get isLoadingMetierAlert => _isLoadingMetierAlert;
  bool get isLoadingDepartements => _isLoadingDepartements;
  bool get isLoadingEtablissement => _isLoadingEtablissement;
  bool get isLoadingFourchette => _isLoadingFourchette;
  bool get isLoadingSituationActivites => _isLoadingSituationActivites;
  bool get isLoadingSituationExperiences => _isLoadingSituationExperiences;
  bool get isLoadingDisponibilite => _isLoadingDisponibilite;
  bool get isLoadingPays => _isLoadingPays;
  bool get isLoadingMobilite => _isLoadingMobilite;
  bool get isLoadingLangues => _isLoadingLangues;
  bool get isLoadingNiveaux => _isLoadingNiveaux;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool _isError = false;
  bool get isError => _isError;

  Future<void> fetchSecteurActivites() async {
    _isLoadingSecteur = true;
    _error = null;
    try {
      _secteurActivites = await _apiService.fetchSecteurActivite();
    } catch (e) {
      _error = 'Une erreur est survenue';
    } finally {
      _isLoadingSecteur = false;
      notifyListeners();
    }
  }
  Future<void> fetchDepartementsByRegion(int idRegion) async {
    _isLoadingDepartements = true;
    try {

      final fetchedDepartements = await _apiService.fetchDepartementsByRegion(idRegion);

      if (_departements.isNotEmpty){
        _departements.clear();
      }
      _departements.addAll(fetchedDepartements);


      _isLoadingDepartements = false;
      _isError = false;
    } catch (e) {
      _isLoadingDepartements = false;
      _isError = true;
    }
    notifyListeners();
  }

  Future<void> fetchMetiersBySecteur(int idSecteur) async {
    _isLoadingMetier = true;
    try {

      final fetchedMetier = await _apiService.fetchMetiersBySecteur(idSecteur);

      print('fetchedMetier:${fetchedMetier}');
      print('fetchedMetier.length:${fetchedMetier.length}');

      print('metier before clear ${_metiers}');
      print('metier.length before clear ${_metiers.length}');

      if (_metiers.isNotEmpty){
        _metiers.clear();
      }
      print('metier after clear ${_metiers}');
      print('metier.length after clear ${_metiers.length}');
      _metiers.addAll(fetchedMetier);
      print('metier after add ${_metiers}');
      print('metier.length after add ${_metiers.length}');
      _isLoadingMetier = false;
      _isError = false;
    } catch (e) {
      _isLoadingMetier = false;
      _isError = true;
    }
    notifyListeners();
  }
  Future<void> fetchMetiersBySecteurAlert(int idSecteur) async {
    _isLoadingMetierAlert = true;
    try {

      final fetchedMetierAlert = await _apiService.fetchMetiersBySecteur(idSecteur);


      if (_metiersAlert.isNotEmpty){
        _metiersAlert.clear();
      }
      _metiersAlert.addAll(fetchedMetierAlert);
      _isLoadingMetierAlert = false;
      _isError = false;
    } catch (e) {
      _isLoadingMetierAlert = false;
      _isError = true;
    }
    notifyListeners();
  }
  Future<void> fetchEtablissementsByFormation(int idFormation) async {
    _isLoadingEtablissement = true;
    try {


      if (idFormation == 23){
        _etablissements.clear();
      }else{
        final fetchedEtablissements = await _apiService.fetchEtablissementByFormation(idFormation);
        if (_etablissements.isNotEmpty){
          _etablissements.clear();
        }
        _etablissements.addAll(fetchedEtablissements);
      }



      _isLoadingEtablissement = false;
      _isError = false;
    } catch (e) {
      _isLoadingEtablissement = false;
      _isError = true;
    }
    notifyListeners();
  }

  Future<void> fetchListePays() async {
    _isLoadingPays = true;
    _error = null;
    try {
      _listePays = await _apiService.fetchListePays();
    } catch (e) {
      _error = 'Une erreur est survenue';
    } finally {
      _isLoadingPays = false;
      notifyListeners();
    }
  }
  Future<void> fetchFourchetteRemuneration() async {
    _isLoadingFourchette = true;
    _error = null;
    try {
      _fourchettes = await _apiService.fetchFourchetteRemuneration();
    } catch (e) {
      _error = 'Une erreur est survenue';
    } finally {
      _isLoadingFourchette = false;
      notifyListeners();
    }
  }
  Future<void> fetchSituationActivites() async {
    _isLoadingSituationActivites = true;
    _error = null;
    try {
      _situationActivites = await _apiService.fetchSituationActivites();
    } catch (e) {
      _error = 'Une erreur est survenue';
    } finally {
      _isLoadingSituationActivites = false;
      notifyListeners();
    }
  }
  Future<void> fetchSituationExperiences() async {
    _isLoadingSituationExperiences = true;
    _error = null;
    try {
      _situationExperiences = await _apiService.fetchSituationExperiences();
    } catch (e) {
      _error = 'Une erreur est survenue';
    } finally {
      _isLoadingSituationExperiences = false;
      notifyListeners();
    }
  }
  Future<void> fetchDisponibilite() async {
    _isLoadingDisponibilite = true;
    _error = null;
    try {
      _disponibilites = await _apiService.fetchDisponibilite();
    } catch (e) {
      _error = 'Une erreur est survenue';
    } finally {
      _isLoadingDisponibilite = false;
      notifyListeners();
    }
  }

  Future<void> fetchMobilite() async {
    _isLoadingMobilite = true;
    _error = null;
    try {
      _mobilites = await _apiService.fetchMobilite();
    } catch (e) {
      _error = 'Une erreur est survenue';
    } finally {
      _isLoadingMobilite = false;
      notifyListeners();
    }
  }
  Future<void> fetchLangues() async {
    _isLoadingLangues = true;
    _error = null;
    try {
      _langues = await _apiService.fetchLangues();
    } catch (e) {
      _error = 'Une erreur est survenue';
    } finally {
      _isLoadingLangues = false;
      notifyListeners();
    }
  }
  Future<void> fetchNiveauxLangue() async {
    _isLoadingNiveaux = true;
    _error = null;
    try {
      _niveaux = await _apiService.fetchNiveauxLangues();
    } catch (e) {
      _error = 'Une erreur est survenue';
    } finally {
      _isLoadingNiveaux = false;
      notifyListeners();
    }
  }
  Future<void> fetchJobTitles(String query) async {
    _isLoadingJobs = true;
    _error = null;
    try {
      final jobs = await _apiService.fetchJobTitles(query);
      _jobTitles.addAll(jobs);
      print("length of jobs ${_jobTitles.length}");
    } catch (e) {
      _error = 'Une erreur est survenue';
    } finally {
      _isLoadingJobs = false;
      notifyListeners();
    }
  }
  Future<void> fetchAllDropdownData() async {
    _isLoading = true;

    await fetchSecteurActivites();
    await fetchFourchetteRemuneration();
    await fetchSituationActivites();
    await fetchSituationExperiences();
    await fetchMobilite();
    await fetchDisponibilite();
    await fetchLangues();
    await fetchNiveauxLangue();

    _isLoading = false;
    notifyListeners();
  }
}
