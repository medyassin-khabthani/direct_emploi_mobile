import 'package:json_annotation/json_annotation.dart';

part 'geo_adresse_model.g.dart';

@JsonSerializable()
class GeoAdresse {
  final String? adresse;
  final String? complement;
  final String? codePostal;
  final String? ville;
  final int? pays;

  GeoAdresse({
    this.adresse,
    this.complement,
    this.codePostal,
    this.ville,
    this.pays,
  });

  factory GeoAdresse.fromJson(Map<String, dynamic> json) =>
      _$GeoAdresseFromJson(json);

  Map<String, dynamic> toJson() => _$GeoAdresseToJson(this);
}