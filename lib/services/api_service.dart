import 'package:dio/dio.dart';
import '../models/alert_model.dart';
import '../models/configuration_model.dart';
import '../models/cv_model.dart';
import '../models/offre_model.dart';
import '../models/personal_info_model.dart';
import '../models/saved_search_model.dart';
import 'dart:io';

import '../models/similar_offre_model.dart';

class ApiService {
  static const String baseUrl2 = 'https://www.directemploi.com/api';
  static const String baseUrl = 'https://www.directemploi.com/api';
  static const String baseUrlLocal = 'http://10.0.2.2:8000/api';

  final Dio _dio = Dio();

  Future<Map<String, dynamic>> searchOffers(int userId, Map<String, dynamic> queryParams) async {
    final String url = '$baseUrl2/elasticsearch/searchOffers/$userId';

    try {
      Response response = await _dio.get(url, queryParameters: queryParams,);
      if (response.statusCode == 200) {
        List<Offre> offers = Offre.fromJsonList(response.data['results']);
        int total = response.data['total'];
        String idSearch = response.data['idSearch'];
        return {'offers': offers, 'total': total,'idSearch': idSearch};
      } else {
        throw Exception('Failed to load job offers');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load job offers');
    }
  }

  Future<Map<String, dynamic>> searchOffersWithoutSave(int userId, Map<String, dynamic> queryParams) async {
    final String url = '$baseUrl2/elasticsearch/searchOffersWithoutSave/$userId';

    try {
      Response response = await _dio.get(url, queryParameters: queryParams);

      if (response.statusCode == 200) {

        List<Offre> offers = Offre.fromJsonList(response.data['results']);
        int total = response.data['total'];
        return {'offers': offers, 'total': total};
      } else {
        throw Exception('Failed to load job offers');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load job offers');
    }
  }

  Future<Map<String, dynamic>> searchOffersByDate(int userId, Map<String, dynamic> queryParams) async {
    final String url = '$baseUrl2/elasticsearch/searchOffersByDate/$userId';

    try {
      Response response = await _dio.get(url, queryParameters: queryParams,);
      if (response.statusCode == 200) {
        List<Offre> offers = Offre.fromJsonList(response.data['results']);
        int total = response.data['total'];
        String idSearch = response.data['idSearch'];
        return {'offers': offers, 'total': total,'idSearch': idSearch};
      } else {
        throw Exception('Failed to load job offers');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load job offers');
    }
  }

  Future<Map<String, dynamic>> searchOffersWithoutSaveByDate(int userId, Map<String, dynamic> queryParams) async {
    final String url = '$baseUrl2/elasticsearch/searchOffersWithoutSaveByDate/$userId';

    try {
      Response response = await _dio.get(url, queryParameters: queryParams);

      if (response.statusCode == 200) {

        List<Offre> offers = Offre.fromJsonList(response.data['results']);
        int total = response.data['total'];
        return {'offers': offers, 'total': total};
      } else {
        throw Exception('Failed to load job offers');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load job offers');
    }
  }

  Future<Map<String, dynamic>> searchByEntreprise(String entreprise, int offset, int limit) async {
    final String url = '$baseUrl2/elasticsearch/search/entreprise';

    try {
      Response response = await _dio.get(url, queryParameters: {
        'entreprise': entreprise,
        'offset': offset,
        'limit': limit,
      });

      if (response.statusCode == 200) {
        List<Offre> offers = Offre.fromJsonList(response.data['results']);
        int total = response.data['total'];
        return {'offers': offers, 'total': total};
      } else {
        throw Exception('Failed to load job offers by entreprise');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load job offers by entreprise');
    }
  }
  Future<Map<String, dynamic>> saveUserConfiguration(int userId, Map<String, dynamic> configuration) async {
    final String url = '$baseUrl/user-configuration/$userId';

    try {
      Response response = await _dio.post(
        url,
        data: {'configuration': configuration},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to save configuration');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to save configuration');
    }
  }

  Future<Configuration> getUserConfiguration(int userId) async {
    final String url = '$baseUrl/user-configuration/$userId';

    try {
      Response response = await _dio.get(url);

      if (response.statusCode == 200) {
        return Configuration.fromJson(response.data[0]);
      } else {
        throw Exception('Failed to load configuration');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load configuration');
    }
  }

  Future<Map<String, dynamic>> extractCvText(int cvId) async {
    final String url = '$baseUrl/extract-cv-text';

    try {
      FormData formData = FormData.fromMap({
        'cvId': cvId
      });

      Response response = await _dio.post(url, data: formData,options:Options(validateStatus:(status)=> true));
      print(response.data);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to extract cv text');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to extract cv text');
    }
  }

  Future<Map<String, dynamic>> extractJobTitles(String cvText,String cvFile) async {
    final String url = '$baseUrlLocal/extract-job-titles';

    try {
      FormData formData = FormData.fromMap({
        'cvText': cvText,
        'cvFile': cvFile
      });

      Response response = await _dio.post(url, data: formData,options:Options(validateStatus:(status)=> true));
      print(response.data);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to extract job titles');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to extract job titles');
    }
  }

  Future<Map<String, dynamic>> updateUserConfiguration(int userId, String id, Map<String, dynamic> configuration) async {
    final String url = '$baseUrl/user-configuration/$userId/$id';

    try {
      Response response = await _dio.put(
        url,
        data: {'configuration': configuration},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to update configuration');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to update configuration');
    }
  }
  Future<Map<String, dynamic>> saveSearch(int userId, Map<String, dynamic> searchParams) async {
    String url = '$baseUrl/saved-searches/$userId';

    final response = await _dio.post(
      url,
      data: {
        'searchParams': searchParams,
      },
    );
    return response.data;
  }

  Future<List<SavedSearch>> fetchSavedSearches(String userId) async {
    try {
      final response = await _dio.get('$baseUrl/elasticsearch/saved-searches/$userId');
      List<dynamic> body = response.data;
      return body.map((dynamic item) => SavedSearch.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load saved searches');
    }
  }

  Future<Offre> fetchOfferDetails(String id) async {
    final String url = '$baseUrl2/elasticsearch/offer/$id';

    try {
      Response response = await _dio.get(url);

      if (response.statusCode == 200) {
        return Offre.fromJson(response.data);
      } else {
        throw Exception('Failed to load offer details');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load offer details');
    }
  }

  Future<void> updateSavedSearch(String userId, String id, Map<String, dynamic> queryParams) async {
    final String url = '$baseUrl/elasticsearch/saved-search/update/$userId/$id';

    try {
      Response response = await _dio.put(url, queryParameters: queryParams);

      if (response.statusCode != 200) {
        throw Exception('Failed to update saved search');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to update saved search');
    }
  }

  Future<void> deleteSavedSearch(String id) async {
    final String url = '$baseUrl/elasticsearch/saved-search/delete/$id';

    try {
      Response response = await _dio.delete(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to delete saved search');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to delete saved search');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final String url = '$baseUrl/login';

    try {
      Response response = await _dio.post(
        url,
        data: {'username': email, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to login: ${response.data}');
      }
    } on DioError catch (e) {
      throw Exception('Failed to login: ${e.response?.data ?? e.message}');
    }
  }

  Future<Map<String, dynamic>> createQuickAccount(String email) async {
    const url = '$baseUrl/create-quick-account';
    try {
      final response = await _dio.post(
        url,
        data: {'email': email},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to create account: ${response.data}');
      }
    } on DioError catch (e) {
      throw Exception('Failed to create account: ${e.response?.data ?? e.message}');
    }
  }
  Future<List<Alert>> fetchUserAlerts(int userId) async {
    final String url = '$baseUrl/alerts/$userId';

    try {
      Response response = await _dio.get(url);
      if (response.statusCode == 200) {
        List<dynamic> body = response.data;
        return body.map((dynamic item) => Alert.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load alerts');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load alerts');
    }
  }
  Future<List<int>> fetchSavedOffers(int userId) async {
    final response = await _dio.get('$baseUrl/$userId/saved-offers');
    print(response.data);
    return List<int>.from(response.data);
  }

  Future<void> saveOffer(int userId, int offerId) async {
    final response = await _dio.post('$baseUrl/save-offer', data: {'userId':userId,'offerId': offerId});
    print(response.data);
  }

  Future<void> unsaveOffer(int userId, int offerId) async {
    final response = await _dio.post('$baseUrl/unsave-offer', data: {'userId':userId,'offerId': offerId});
    print(response.data);
  }

  Future<Map<String, dynamic>> fetchProfileCompletion(int userId) async {
    final String url = '$baseUrl/profile-completion/$userId';

    try {
      Response response = await _dio.get(url,options:Options(validateStatus:(status)=> true));
      print(response.data);

      if (response.statusCode == 200) {
        print(response.data);
        return response.data;
      }else if (response.statusCode == 404){
        print(response.data);
        return {"error": "404"};
      } else{
        print(response.data);

        throw Exception('Failed to fetch profile completion');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch profile completion');
    }
  }

  Future<void> toggleProfileVisibility(int userId) async {
    final String url = '$baseUrl/cvs/toggle-profile-visibility/$userId';
    try {
      await _dio.patch(url);
    } catch (e) {
      throw Exception('Failed to toggle profile visibility');
    }
  }

  Future<void> toggleNewsletter(int userId) async {
    final String url = '$baseUrl/cvs/toggle-newsletter/$userId';
    try {
      await _dio.patch(url);
    } catch (e) {
      throw Exception('Failed to toggle newsletter');
    }
  }

  Future<void> toggleAlertActif(int alertId) async {
    final String url = '$baseUrl/alerts/$alertId/toggle';

    try {
      Response response = await _dio.post(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to toggle alert status');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to toggle alert status');
    }
  }
  Future<void> deleteAlert(int alertId) async {
    final String url = '$baseUrl/alerts/delete/$alertId';

    try {
      Response response = await _dio.delete(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to delete alert');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to delete alert');
    }
  }
  Future<void> toggleCvVisibility(int cvId) async {
    final String url = '$baseUrl/cvs/toggle-visibility/$cvId';

    try {
      Response response = await _dio.patch(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to toggle CV visibility');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to toggle CV visibility');
    }
  }

  Future<void> deleteCv(int cvId) async {
    final String url = '$baseUrl/cvs/delete/$cvId';

    try {
      Response response = await _dio.delete(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to delete CV');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to delete CV');
    }
  }
  Future<PersonalInfo> fetchPersonalInfo(int userId) async {
    final String url = '$baseUrl/personal-info/$userId';

    try {
      Response response = await _dio.get(url);

      if (response.statusCode == 200) {
        print(response.data);
        return PersonalInfo.fromJson(response.data);
      } else {
        throw Exception('Failed to load personal information');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load personal information');
    }
  }

  Future<void> updatePersonalInfo(int userId, PersonalInfo personalInfo) async {
    final String url = '$baseUrl/personal-info/$userId';

    final data = {
      'civilite': personalInfo.civilite,
      'nom': personalInfo.nom,
      'prenom': personalInfo.prenom,
      'telephone': personalInfo.telephone,
      'email': personalInfo.email,
      'geo_adresse': {
        'adresse': personalInfo.geoAdresse?.adresse,
        'complement': personalInfo.geoAdresse?.complement,
        'codePostal': personalInfo.geoAdresse?.codePostal,
        'ville': personalInfo.geoAdresse?.ville,
        'pays': personalInfo.geoAdresse?.pays,
      }
    };

    try {
      print('Sending PUT request to $url with data: $data');
      Response response = await _dio.put(url, data: data);
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
    } catch (e) {
      print('Error: ${e.toString()}');
      throw Exception('Failed to update personal info: ${e.toString()}');
    }
  }

  Future<void> uploadCv(int userId, File cvFile, int isVisible, int isAnonym) async {
    final String url = '$baseUrl/upload-cv/$userId';
    final formData = FormData.fromMap({
      'cv_file': await MultipartFile.fromFile(cvFile.path),
      'isVisible': isVisible,
      'isAnonym': isAnonym,
    });

    try {
      Response response = await _dio.post(url, data: formData);
      if (response.statusCode == 200) {
        print('CV uploaded successfully');
      } else {
        throw Exception('Failed to upload CV');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to upload CV: ${e.toString()}');
    }
  }


  Future<List<Cv>> fetchUserCvs(int userId) async {
    final String url = '$baseUrl/user-cvs/$userId';

    try {
      Response response = await _dio.get(url,options: Options(validateStatus: (status) => true));
      if (response.statusCode == 200) {
        print(response.data);
        List<Cv> cvs = (response.data as List)
            .map((cvData) => Cv.fromJson(cvData))
            .toList();
        return cvs;
      } else {
        print(response.data);

        throw Exception('Failed to load user CVs');
      }
    } catch (e) {

      print('Error: $e');
      throw Exception('Failed to load user CVs');
    }
  }
  Future<void> updateUserSituation(int userId, Map<String, dynamic> data) async {
    final String url = '$baseUrl/user-situation/$userId';

    try {
      Response response = await _dio.put(url, data: data);
      if (response.statusCode == 200) {
        print('User situation updated successfully');
      } else {
        throw Exception('Failed to update user situation');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to update user situation: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> fetchUserSituationAndCompetences(int userId) async {
    final String url = '$baseUrl/user-situation-competences/$userId';

    try {
      Response response = await _dio.get(url);
      if (response.statusCode == 200) {
        print("USER SITUATION: ${response.data}");
        return response.data;
      } else {
        throw Exception('Failed to load user situation and competences');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load user situation and competences');
    }
  }
  Future<Map<String, dynamic>> changePassword(int userId, String oldPassword, String newPassword) async {
    final String url = '$baseUrl/change-password/$userId';

    try {
      final response = await _dio.post(
        url,
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode != 200) {
        return {
          'success': false,
          'error': response.data['error'] ?? 'Failed to change password'
        };
      }
      return {'success': true, 'message': 'Password changed successfully'};
    } on DioError catch (e) {
      if (e.response != null && e.response!.data != null) {
        return {
          'success': false,
          'error': e.response!.data['error'] ?? 'Failed to change password'
        };
      } else {
        return {'success': false, 'error': 'Failed to change password'};
      }
    }
  }

  Future<List<Offre>> fetchFavoriteOffers(List<int> favOffersIds) async {
    final String url = '$baseUrl/offers-by-ids';
    try {
      Response response = await _dio.post(url,
        data: {
        'ids': favOffersIds,
        },options:Options(validateStatus: (status) => true));

      if (response.statusCode == 200) {
        return Offre.fromJsonList(response.data);
      } else {
        throw Exception('Failed to load favorite offers');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load favorite offers');
    }
  }

  Future<List<Offre>> fetchCandidatureOffers(int userId) async {
    final String url = '$baseUrl/candidature-offers/$userId';
    try {
      Response response = await _dio.get(url);
      if (response.statusCode == 200) {
        return Offre.fromJsonList(response.data);
      } else {
        throw Exception('Failed to load candidature offers');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load candidature offers');
    }
  }
  Future<void> setPassword(int userId, String password) async {
    final String url = '$baseUrl/set-password/$userId';

    try {
      Response response = await _dio.post(
        url,
        data: {'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to set password: ${response.data}');
      }
    } on DioError catch (e) {
      throw Exception('Failed to set password: ${e.response?.data ?? e.message}');
    }
  }

  Future<Map<String,dynamic>> applyForOffer({
    required int userId,
    required int offerId,
    required String email,
    required String prenom,
    required String nom,
    File? cvFile,
    File? lmFile,
    int? cvId,
    bool isCvLocal = false,
  }) async {
    final String url = '$baseUrl/mobile/apply/$userId/$offerId';

    FormData formData = FormData.fromMap({
      'email': email,
      'prenom': prenom,
      'nom': nom,
      'isCvLocal': isCvLocal ? true : false,
    });

    if (isCvLocal && cvId != null) {
      formData.fields.add(MapEntry('cvId', cvId.toString()));
    } else if (cvFile != null) {
      formData.files.add(MapEntry(
        'cv',
        await MultipartFile.fromFile(cvFile.path, filename: cvFile.path.split('/').last),
      ));
    }

    if (lmFile != null) {
      formData.files.add(MapEntry(
        'lm',
        await MultipartFile.fromFile(lmFile.path, filename: lmFile.path.split('/').last),
      ));
    }

    try {
      Response response = await _dio.post(url, data: formData,options: Options(validateStatus: (status) => true));
      print(response.data);
      if (response.statusCode != 200) {
        throw Exception('Failed to apply for the offer: ${response.data}');
      }else{
        return {
          'cv': response.data['cv'],
          'lm': response.data['lm'],
        };
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to apply for the offer: ${e.toString()}');
    }
  }
  Future<List<int>> fetchAppliedOffers(int userId) async {
    final String url = '$baseUrl/applied-offers/$userId';

    try {
      Response response = await _dio.get(url);
      if (response.statusCode == 200) {
        return List<int>.from(response.data);
      } else {
        throw Exception('Failed to load applied offers');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load applied offers');
    }
  }
  Future<List<SimilarOffre>> fetchSimilarOffers(int offerId) async {
    final String url = '$baseUrl/$offerId/similar';

    try {
      Response response = await _dio.get(url);
      if (response.statusCode == 200) {
        List<dynamic> body = response.data['offres'];
        return SimilarOffre.fromJsonList(body);
      } else {
        throw Exception('Failed to load similar offers');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load similar offers');
    }
  }

  Future<Map<String, dynamic>> applyToSimilarOffer({
    required int userId,
    required int offerId,
    required String email,
    required String prenom,
    required String nom,
    required String cv,
    String? lm,
  }) async {
    final String url = '$baseUrl/$userId/$offerId/similar/apply';

    FormData formData = FormData.fromMap({
      'email': email,
      'prenom': prenom,
      'nom': nom,
      'cv': cv,
    });

    if (lm != null) {
      formData.fields.add(MapEntry('lm', lm));
    }

    try {
      Response response = await _dio.post(url, data: formData);
      if (response.statusCode != 200) {
        throw Exception('Failed to apply for the similar offer: ${response.data}');
      } else {
        return response.data;
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to apply for the similar offer: ${e.toString()}');
    }
  }
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final String url = '$baseUrl/forgot-password';

    try {
      final response = await _dio.post(
        url,
        data: {'email': email},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      return {'success': false, 'error': e.response?.data['error'] ?? 'Failed to send reset code'};
    }
  }

  Future<Map<String, dynamic>> verifyResetCode(String email, String code) async {
    final String url = '$baseUrl/verify-reset-code';

    try {
      final response = await _dio.post(
        url,
        data: {'email': email, 'code': code},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return response.data;
    } on DioError catch (e) {
      return {'success': false, 'error': e.response?.data['error'] ?? 'Failed to verify reset code'};
    }
  }

  Future<Map<String, dynamic>> resetPassword(String email, String code, String newPassword) async {
    final String url = '$baseUrl/reset-password';

    try {
      final response = await _dio.post(
        url,
        data: {'email': email, 'code': code, 'newPassword': newPassword},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return response.data;
    } on DioError catch (e) {
      return {'success': false, 'error': e.response?.data['error'] ?? 'Failed to reset password'};
    }
  }
  Future<Map<String, dynamic>> registerStep1(Map<String, dynamic> data, File? cvFile) async {
    final String url = '$baseUrl/register';
    FormData formData = FormData.fromMap(data);

    if (cvFile != null) {
      formData.files.add(MapEntry(
        'cv_file',
        await MultipartFile.fromFile(cvFile.path, filename: cvFile.path.split('/').last),
      ));
    }

    try {
      Response response = await _dio.post(url, data: formData,options: Options(validateStatus: (status) => true));
      print(response.data);
      if (response.statusCode == 400){
        return {'success' : false, 'error':'Cet email est existant'};
      }else{
        return response.data;
      }
    } catch (e) {
      print('Error: $e');
      return {'success':false};
    }
  }

  Future<bool> registerStep2(Map<String, dynamic> data) async {
    final String url = '$baseUrl/register/step2';

    try {
      Response response = await _dio.post(url, data: data,options: Options(validateStatus: (status) => true));
      print(response.data);
      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> registerStep3(Map<String, dynamic> data) async {
    final String url = '$baseUrl/register/step3';

    try {
      Response response = await _dio.post(url, data: data);
      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
  Future<void> deleteUser(int userId) async {
    final String url = '$baseUrl/user/delete/$userId';

    try {
      Response response = await _dio.delete(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to delete user account');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to delete user account');
    }
  }
  /* Data fetching */

  Future<Map<int, String>> fetchSecteurActivite() async {
    const String url = '$baseUrl/secteur_activite';

    try {
      Response response = await _dio.get(url,options: Options(validateStatus: (status) => true));
      print(response.data);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        return data.map((key, value) => MapEntry(int.parse(key), value));
      } else {
        print(response.data);

        throw Exception('Failed to load secteur activite');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load secteur activite');
    }
  }

  Future<Map<int, String>> fetchMetiersBySecteur(int idSecteur) async {
    final String url = '$baseUrl/metiers/$idSecteur';

    try {
      Response response = await _dio.get(url,options: Options(validateStatus: (status) => true));
      print(response.data);

      if (response.statusCode == 200) {

        Map<int, String> metiers = {};
        response.data.forEach((key, value) {
          metiers[int.parse(key)] = value;
        });
        return metiers;
      } else {
        print(response.data);

        throw Exception('Failed to load metiers');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load metiers');
    }
  }
  Future<Map<int, String>> fetchDepartementsByRegion(int idRegion) async {
    final String url = '$baseUrl/departements/$idRegion';

    try {
      Response response = await _dio.get(url,options: Options(validateStatus: (status) => true));
      print(response.data);

      if (response.statusCode == 200) {

        Map<int, String> departements = {};
        response.data.forEach((key, value) {
          departements[int.parse(key)] = value;
        });
        return departements;
      } else {
        print(response.data);

        throw Exception('Failed to load metiers');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load metiers');
    }
  }

  Future<Map<int, String>> fetchListePays() async {
    const String url = '$baseUrl/liste_pays';

    try {
      Response response = await _dio.get(url,options: Options(validateStatus: (status) => true));

      if (response.statusCode == 200) {
        print(response.data);
        Map<String, dynamic> data = response.data;
        return data.map((key, value) => MapEntry(int.parse(key), value));
      } else {
        throw Exception('Failed to load liste pays');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load liste pays');
    }
  }
  Future<Map<int, String>> fetchEtablissementByFormation(int idFormation) async {
    final String url = '$baseUrl/etablissements/$idFormation';

    try {
      Response response = await _dio.get(url,options: Options(validateStatus: (status) => true));
      print(response.data);

      if (response.statusCode == 200) {

        Map<int, String> etablissements = {};
        response.data.forEach((key, value) {
          etablissements[int.parse(key)] = value;
        });
        return etablissements;
      } else {
        print(response.data);

        throw Exception('Failed to load etablissements');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load etablissements');
    }
  }

  Future<Map<int, String>> fetchFourchetteRemuneration() async {
    const String url = '$baseUrl/remuneration_fourchette';

    try {
      Response response = await _dio.get(url,options: Options(validateStatus: (status) => true));
      print(response.data);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        return data.map((key, value) => MapEntry(int.parse(key), value));
      } else {
        print(response.data);

        throw Exception('Failed to load remuneration fourchette');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load remuneration fourchette');
    }
  }

  Future<Map<int, String>> fetchSituationActivites() async {
    const String url = '$baseUrl/situation_activite';

    try {
      Response response = await _dio.get(url,options: Options(validateStatus: (status) => true));
      print(response.data);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        return data.map((key, value) => MapEntry(int.parse(key), value));
      } else {
        print(response.data);

        throw Exception('Failed to load Situtation Activites');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load Situtation Activites');
    }
  }

  Future<Map<int, String>> fetchSituationExperiences() async {
    const String url = '$baseUrl/situation_experience';

    try {
      Response response = await _dio.get(url,options: Options(validateStatus: (status) => true));
      print(response.data);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        return data.map((key, value) => MapEntry(int.parse(key), value));
      } else {
        print(response.data);

        throw Exception('Failed to load Situtation Experience');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load Situtation Experience');
    }
  }

  Future<Map<int, String>> fetchDisponibilite() async {
    const String url = '$baseUrl/disponibilite';

    try {
      Response response = await _dio.get(url,options: Options(validateStatus: (status) => true));
      print(response.data);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        return data.map((key, value) => MapEntry(int.parse(key), value));
      } else {
        print(response.data);

        throw Exception('Failed to load Disponibilite');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load Disponibilite');
    }
  }

  Future<Map<int, String>> fetchMobilite() async {
    const String url = '$baseUrl/mobilite';

    try {
      Response response = await _dio.get(url,options: Options(validateStatus: (status) => true));
      print(response.data);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        return data.map((key, value) => MapEntry(int.parse(key), value));
      } else {
        print(response.data);

        throw Exception('Failed to load mobilite');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load mobilite');
    }
  }

  Future<Map<int, String>> fetchLangues() async {
    const String url = '$baseUrl/liste_langues';

    try {
      Response response = await _dio.get(url,options: Options(validateStatus: (status) => true));
      print(response.data);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        return data.map((key, value) => MapEntry(int.parse(key), value));
      } else {
        print(response.data);

        throw Exception('Failed to load liste langues');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load liste langues');
    }
  }
  Future<Map<int, String>> fetchNiveauxLangues() async {
    const String url = '$baseUrl/niveau_langue';

    try {
      Response response = await _dio.get(url,options: Options(validateStatus: (status) => true));
      print(response.data);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        return data.map((key, value) => MapEntry(int.parse(key), value));
      } else {
        print(response.data);

        throw Exception('Failed to load niveau langue');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load niveau langue');
    }
  }
  Future<List<String>> fetchJobTitles(String query) async {
    final String url = '$baseUrl/job-titles';
    try {
      final response = await _dio.get(url, queryParameters: {'q': query});

      print(response.data);
      if (response.statusCode == 200) {
        List<dynamic> jobTitles = response.data;
        return jobTitles.map((job) => job['libelle'] as String).toList();
      } else {
        throw Exception('Failed to fetch job titles');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch job titles');
    }
  }
}
