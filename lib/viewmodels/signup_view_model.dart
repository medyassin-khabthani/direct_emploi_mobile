import 'dart:io';

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/user_manager.dart';

class SignupViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? _errorSignup;
  String? get error => _error;
  String? get errorSignup => _errorSignup;

  Map<String, dynamic>? _user;
  Map<String, dynamic>? get user => _user;

  int? _userId;
  int? get userId => _userId;

  UserManager userManager = UserManager.instance;

  Future<void> createQuickAccount(String email) async {
    _isLoading = true;
    _error = null;

    try {
      _user = await _apiService.createQuickAccount(email);
      if (_user != null && _user!['userId'] != null) {
        await saveUserConfiguration(_user!['userId'],{"based":"none"}
        );
        await userManager.storeUserId(_user!['userId']);
        userManager.setUserId(_user!['userId']);
      }
      _isLoading = false;
      _error = null;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
    }
    notifyListeners();
  }
  Future<bool> registerStep1(Map<String, dynamic> data, File? cvFile) async {
    _isLoading = true;
    notifyListeners();
    _errorSignup = null;

    print(data);
     final response = await _apiService.registerStep1(data, cvFile);

     if ( response['success'] == true ){
       _userId  = response['userId'];
       await saveUserConfiguration(response['userId'],{"based":"none"}
       );
       await userManager.storeToken(response['token']);
       await userManager.setUserIdViaToken();

       bool success = true;
       _isLoading = false;
       notifyListeners();

       return success;
     }else{
       _errorSignup = response['error'];
       _isLoading = false;
       notifyListeners();
       return false;
     }


  }

  Future<bool> registerStep2(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    data["userId"] = _userId;

    bool success = await _apiService.registerStep2(data);

    _isLoading = false;
    notifyListeners();

    return success;
  }

  Future<bool> registerStep3(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    data["userId"] = _userId;

    bool success = await _apiService.registerStep3(data);

    _isLoading = false;
    notifyListeners();

    return success;
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    _error = null;

    try {
      final response = await _apiService.login(email, password);
      if (response.containsKey('token')) {
        await userManager.storeToken(response['token']);
        await userManager.setUserIdViaToken();
        _isLoading = false;
        notifyListeners();

        return true;
      } else {
        _error = "Votre email ou mot de passe sont invalides.";
        _isLoading = false;
        notifyListeners();

        return false;
      }
    } catch (e) {
      _error = "Votre email ou mot de passe sont invalides.";
      _isLoading = false;
      notifyListeners();

      return false;
    }

  }
  Future<void> saveUserConfiguration(int userId,Map<String, dynamic> configuration) async {
    _isLoading = true;

    try {
      await _apiService.saveUserConfiguration(userId, configuration);
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
    }
    notifyListeners();
  }
}
