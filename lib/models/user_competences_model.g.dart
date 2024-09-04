// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_competences_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCompetences _$UserCompetencesFromJson(Map<String, dynamic> json) =>
    UserCompetences(
      competences: json['competences'] as String?,
      idChoixLangue1: (json['idChoixLangue1'] as num?)?.toInt(),
      idNiveauLangue1: (json['idNiveauLangue1'] as num?)?.toInt(),
      idChoixLangue2: (json['idChoixLangue2'] as num?)?.toInt(),
      idNiveauLangue2: (json['idNiveauLangue2'] as num?)?.toInt(),
      permisB: (json['permisB'] as num?)?.toInt(),
      isProfileVisible: (json['isProfileVisible'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserCompetencesToJson(UserCompetences instance) =>
    <String, dynamic>{
      'competences': instance.competences,
      'idChoixLangue1': instance.idChoixLangue1,
      'idNiveauLangue1': instance.idNiveauLangue1,
      'idChoixLangue2': instance.idChoixLangue2,
      'idNiveauLangue2': instance.idNiveauLangue2,
      'permisB': instance.permisB,
      'isProfileVisible': instance.isProfileVisible,
    };
