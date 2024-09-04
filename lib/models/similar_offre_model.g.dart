// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'similar_offre_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimilarOffre _$SimilarOffreFromJson(Map<String, dynamic> json) => SimilarOffre(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      mission: json['mission'] as String,
      contractType: json['contractType'] as String,
      reference: json['reference'] as String,
      logo: json['logo'] as String,
      ville: json['ville'] as String,
      companyName: json['companyName'] as String,
      dateSoumission: json['dateSoumission'] as String,
      applied: json['applied'] as bool? ?? false,
    );

Map<String, dynamic> _$SimilarOffreToJson(SimilarOffre instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'mission': instance.mission,
      'reference': instance.reference,
      'ville': instance.ville,
      'contractType': instance.contractType,
      'logo': instance.logo,
      'companyName': instance.companyName,
      'dateSoumission': instance.dateSoumission,
      'applied': instance.applied,
    };
