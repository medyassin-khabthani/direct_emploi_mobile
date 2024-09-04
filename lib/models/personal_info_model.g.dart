// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalInfo _$PersonalInfoFromJson(Map<String, dynamic> json) => PersonalInfo(
      civilite: (json['civilite'] as num?)?.toInt(),
      nom: json['nom'] as String?,
      prenom: json['prenom'] as String?,
      telephone: json['telephone'] as String?,
      email: json['email'] as String?,
      passCrypt: json['passCrypt'] as String?,
      geoAdresse: json['geoAdresse'] == null
          ? null
          : GeoAdresse.fromJson(json['geoAdresse'] as Map<String, dynamic>),
      aboNews: (json['aboNews'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PersonalInfoToJson(PersonalInfo instance) =>
    <String, dynamic>{
      'civilite': instance.civilite,
      'nom': instance.nom,
      'prenom': instance.prenom,
      'telephone': instance.telephone,
      'email': instance.email,
      'passCrypt': instance.passCrypt,
      'geoAdresse': instance.geoAdresse,
      'aboNews': instance.aboNews,
    };
