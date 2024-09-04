// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Alert _$AlertFromJson(Map<String, dynamic> json) => Alert(
      id: (json['id'] as num).toInt(),
      libelle: json['libelle'] as String,
      experience: (json['experience'] as num?)?.toInt(),
      actif: (json['actif'] as num).toInt(),
      typeContrat: (json['typeContrat'] as num?)?.toInt(),
      secteurActivite: (json['secteurActivite'] as num?)?.toInt(),
      region: (json['region'] as num?)?.toInt(),
      formation: (json['formation'] as num?)?.toInt(),
      remuneration: (json['remuneration'] as num?)?.toInt(),
      motsCles: json['motsCles'] as String?,
      handicap: (json['handicap'] as num?)?.toInt(),
      isRss: (json['isRss'] as num).toInt(),
      datePassageCron: json['datePassageCron'] as String?,
      departement: (json['departement'] as num?)?.toInt(),
      dateDernierEnvoi: json['dateDernierEnvoi'] as String?,
      userId: (json['userId'] as num).toInt(),
    );

Map<String, dynamic> _$AlertToJson(Alert instance) => <String, dynamic>{
      'id': instance.id,
      'libelle': instance.libelle,
      'experience': instance.experience,
      'actif': instance.actif,
      'typeContrat': instance.typeContrat,
      'secteurActivite': instance.secteurActivite,
      'region': instance.region,
      'formation': instance.formation,
      'remuneration': instance.remuneration,
      'motsCles': instance.motsCles,
      'handicap': instance.handicap,
      'isRss': instance.isRss,
      'datePassageCron': instance.datePassageCron,
      'departement': instance.departement,
      'dateDernierEnvoi': instance.dateDernierEnvoi,
      'userId': instance.userId,
    };
