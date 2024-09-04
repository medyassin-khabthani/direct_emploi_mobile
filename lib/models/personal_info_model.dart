import 'package:json_annotation/json_annotation.dart';
import 'geo_adresse_model.dart';

part 'personal_info_model.g.dart';

@JsonSerializable()
class PersonalInfo {
  final int? civilite;
  final String? nom;
  final String? prenom;
  final String? telephone;
  final String? email;
  final String? passCrypt;
  final GeoAdresse? geoAdresse;
  final int? aboNews;

  PersonalInfo({
    this.civilite,
    this.nom,
    this.prenom,
    this.telephone,
    this.email,
    this.passCrypt,
    this.geoAdresse,
    this.aboNews,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) =>
      _$PersonalInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalInfoToJson(this);
}