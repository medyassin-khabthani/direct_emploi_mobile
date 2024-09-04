// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cv_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cv _$CvFromJson(Map<String, dynamic> json) => Cv(
      id: (json['id'] as num).toInt(),
      titre: json['titre'] as String,
      nomFichierCvOriginal: json['nomFichierCvOriginal'] as String,
      nomFichierCvStockage: json['nomFichierCvStockage'] as String,
      isVisible: (json['isVisible'] as num).toInt(),
      dateCreation: json['dateCreation'] as String,
      dateModification: json['dateModification'] as String,
    );

Map<String, dynamic> _$CvToJson(Cv instance) => <String, dynamic>{
      'id': instance.id,
      'titre': instance.titre,
      'nomFichierCvOriginal': instance.nomFichierCvOriginal,
      'nomFichierCvStockage': instance.nomFichierCvStockage,
      'isVisible': instance.isVisible,
      'dateCreation': instance.dateCreation,
      'dateModification': instance.dateModification,
    };
