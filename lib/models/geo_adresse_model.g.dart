// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_adresse_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoAdresse _$GeoAdresseFromJson(Map<String, dynamic> json) => GeoAdresse(
      adresse: json['adresse'] as String?,
      complement: json['complement'] as String?,
      codePostal: json['codePostal'] as String?,
      ville: json['ville'] as String?,
      pays: (json['pays'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GeoAdresseToJson(GeoAdresse instance) =>
    <String, dynamic>{
      'adresse': instance.adresse,
      'complement': instance.complement,
      'codePostal': instance.codePostal,
      'ville': instance.ville,
      'pays': instance.pays,
    };
