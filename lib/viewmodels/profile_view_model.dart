  import 'dart:io';

  import 'package:flutter/material.dart';
  import '../models/configuration_model.dart';
import '../models/cv_model.dart';
  import '../models/personal_info_model.dart';
  import '../models/user_competences_model.dart';
  import '../models/user_situation_model.dart';
  import '../services/api_service.dart';
  import '../services/user_manager.dart';

  class ProfileViewModel extends ChangeNotifier {
    final ApiService _apiService = ApiService();

    bool _isLoading = false;
    bool _isLoadingUpdate = false;
    bool _isLoadingPersonal = false;
    bool _isLoadingUpdatePersonal = false;
    bool get isLoading => _isLoading;
    bool get isLoadingUpdate => _isLoadingUpdate;
    bool get isLoadingPersonal => _isLoadingPersonal;
    bool get isLoadingUpdatePersonal => _isLoadingUpdatePersonal;

    bool _isError = false;
    bool get isError => _isError;

    Map<String, dynamic>? _profileCompletionData;
    Map<String, dynamic>? get profileCompletionData => _profileCompletionData;

    List<Cv>? _userCvs;
    List<Cv>? get userCvs => _userCvs;

    PersonalInfo? _personalInfo;
    PersonalInfo? get personalInfo => _personalInfo;
    UserSituation? _userSituation;
    UserSituation? get userSituation => _userSituation;

    UserCompetences? _userCompetences;
    UserCompetences? get userCompetences => _userCompetences;

    String? _error;
    String? get error => _error;

    UserManager userManager = UserManager.instance;
    Configuration? _userConfiguration;
    Configuration? get userConfiguration => _userConfiguration;

    Future<void> fetchProfileCompletion(int userId) async {
      _isLoading = true;
      _isError = false;

      try {
        _profileCompletionData = await _apiService.fetchProfileCompletion(userId);
        _isLoading = false;
        _isError = false;
      } catch (e) {
        _isLoading = false;
        _isError = true;
      }
      notifyListeners();
    }

    Future<void> fetchPersonalInfo(int userId) async {
      _isLoadingPersonal = true;
      _error = null;

      try {
        _personalInfo = await _apiService.fetchPersonalInfo(userId);
        print('PERSONAL INFO ${_personalInfo?.geoAdresse == null}');
      } catch (e) {
        _error = e.toString();
      }

      _isLoadingPersonal = false;
      notifyListeners();
    }

    Future<void> updatePersonalInfo(PersonalInfo personalInfo) async {
      _isLoadingUpdatePersonal = true;
      _error = null;
      notifyListeners();

      try {
        print('Updating personal info for userId: ${userManager.userId}');
        await _apiService.updatePersonalInfo(userManager.userId!, personalInfo);
        print('Personal info updated successfully');
      } catch (e) {
        _error = e.toString();
        print('Error updating personal info: $_error');
      }

      _isLoadingUpdatePersonal = false;
      notifyListeners();
    }

    Future<void> uploadCv(File cvFile, int isVisible, int isAnonym) async {
      _isLoadingUpdate = true;
      _error = null;
      notifyListeners();

      try {
        print('Uploading CV for userId: ${userManager.userId}');
        await _apiService.uploadCv(userManager.userId!, cvFile, isVisible, isAnonym);
        fetchUserCvs(userManager.userId!);
        print('CV uploaded successfully');
      } catch (e) {
        _error = e.toString();
        print('Error uploading CV: $_error');
      }

      _isLoading = false;
      notifyListeners();
    }


    Future<void> fetchUserCvs(int userId) async {
      _isLoading = true;
      _error = null;
      try {
        _userCvs = await _apiService.fetchUserCvs(userId);
        print('User CVs fetched successfully');
      } catch (e) {
        _error = e.toString();
        print('Error fetching user CVs: $_error');
      }

      _isLoading = false;
      notifyListeners();
    }
    Future<void> updateUserSituation(Map<String, dynamic> data) async {
      _isLoading = true;
      _error = null;
      notifyListeners();

      try {
        print('Updating user situation for userId: ${userManager.userId}');
        print('Updating user situation with data ${data}');
        await _apiService.updateUserSituation(userManager.userId!, data);
        print('User situation updated successfully');
      } catch (e) {
        _error = e.toString();
        print('Error updating user situation: $_error');
      }

      _isLoading = false;
      notifyListeners();
    }
    Future<void> fetchUserSituationAndCompetences(int userId) async {
      _isLoading = true;
      _isError = false;

      try {
        final data = await _apiService.fetchUserSituationAndCompetences(userId);
        _userSituation = UserSituation.fromJson(data['situation']);
        _userCompetences = UserCompetences.fromJson(data['competences']);
        _isLoading = false;
        _isError = false;
      } catch (e) {
        _isLoading = false;
        _isError = true;
        _error = e.toString();
      }
      notifyListeners();
    }
    Future<void> toggleCvVisibility(int cvId) async {
      try {
        await _apiService.toggleCvVisibility(cvId);
        fetchUserCvs(userManager.userId!);
      } catch (e) {
        _error = e.toString();
        notifyListeners();
      }
    }

    Future<void> deleteCv(int cvId) async {
      try {
        await _apiService.deleteCv(cvId);
        _userCvs!.removeWhere((cv) => cv.id == cvId);
        notifyListeners();
      } catch (e) {
        _error = e.toString();
        notifyListeners();
      }
    }

    Future<void> toggleProfileVisibility() async {
      try {
        await _apiService.toggleProfileVisibility(userManager.userId!);
        fetchUserSituationAndCompetences(userManager.userId!);
      } catch (e) {
        _error = e.toString();
        notifyListeners();
      }
    }

    Future<void> toggleNewsletter() async {
      try {
        await _apiService.toggleNewsletter(userManager.userId!);
        fetchPersonalInfo(userManager.userId!);
      } catch (e) {
        _error = e.toString();
        notifyListeners();
      }
    }

    Future<void> setPassword(String password) async {
      _isLoading = true;
      notifyListeners();
      _error = null;

      try {
        await _apiService.setPassword(userManager.userId!, password);
        print('Password set successfully');
      } catch (e) {
        _error = e.toString();
        print('Error setting password: $_error');
      }
      _isLoading = false;
      notifyListeners();
    }
    Future<Map<String, dynamic>> changePassword(String oldPassword, String newPassword) async {
      _isLoading = true;
      notifyListeners();

      _error = null;

      try {
        final response = await _apiService.changePassword(userManager.userId!, oldPassword, newPassword);
        _isLoading = false;
        if (response['success'] == false) {
          _error = response['error'];
        }
        notifyListeners();
        return response;
      } catch (e) {
        _isLoading = false;
        _error = e.toString();
        notifyListeners();
        return {'success': false, 'error': _error};
      }
    }

    Future<Map<String, dynamic>> forgotPassword(String email) async {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.forgotPassword(email);

      _isLoading = false;
      notifyListeners();

      return response;
    }

    Future<Map<String, dynamic>> verifyResetCode(String email, String code) async {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.verifyResetCode(email, code);

      _isLoading = false;
      notifyListeners();

      return response;
    }

    Future<Map<String, dynamic>> resetPassword(String email, String code, String newPassword) async {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.resetPassword(email, code, newPassword);

      _isLoading = false;
      notifyListeners();

      return response;
    }
    Future<void> getUserConfiguration() async {
      _isLoading = true;
      _isError = false;
      try {
        _userConfiguration = await _apiService.getUserConfiguration(userManager.userId!);
        _isLoading = false;
        _isError = false;
      } catch (e) {
        _isLoading = false;
        _isError = true;
        _error = e.toString();
      }
      notifyListeners();
    }

    Future<void> updateUserConfiguration(String id, Map<String, dynamic> configuration) async {
      _isLoading = true;
      _isError = false;
      notifyListeners();

      try {
        await _apiService.updateUserConfiguration(userManager.userId!, id, configuration);
        _isLoading = false;
        _isError = false;
      } catch (e) {
        _isLoading = false;
        _isError = true;
        _error = e.toString();
      }
      notifyListeners();
    }

    Future<void> saveUserConfiguration(Map<String, dynamic> configuration) async {
      _isLoading = true;
      _isError = false;
      notifyListeners();

      try {
        await _apiService.saveUserConfiguration(userManager.userId!, configuration);
        _isLoading = false;
        _isError = false;
      } catch (e) {
        _isLoading = false;
        _isError = true;
        _error = e.toString();
      }
      notifyListeners();
    }
    Future<void> extractCvText(int cvId,String configId) async {
      _isLoading = true;
      _isError = false;
      notifyListeners();

      try {
        final data = await _apiService.extractCvText(cvId);
        await extractJobTitles(data['cvText'], data['cvFile'],configId);
        _isLoading = false;
        _isError = false;
      } catch (e) {
        _isLoading = false;
        _isError = true;
        _error = e.toString();
        return null;
      }
      notifyListeners();

    }

    Future<void> extractJobTitles(String cvText,String cvFile,String configId) async {
      _isLoading = true;
      _isError = false;
      notifyListeners();

      try {
        final data = await _apiService.extractJobTitles(cvText,cvFile);
        updateUserConfiguration(configId,{"based":"cv","q":data['Designation'],"cvFile":data['cvFile']});
        _isLoading = false;
        _isError = false;
      } catch (e) {
        _isLoading = false;
        _isError = true;
        _error = e.toString();
        return null;
      }
      notifyListeners();

    }
    Future<void> deleteUserAccount(int userId) async {
      _isLoading = true;

      try {
        await _apiService.deleteUser(userId);
        UserManager usermanager = UserManager.instance;
        usermanager.clearUserId();
        usermanager.clearToken();
        notifyListeners();
      } catch (e) {
        _isLoading = false;
        _error = e.toString();
        notifyListeners();
        throw e;
      }
    }
  }
