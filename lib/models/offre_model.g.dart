// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offre_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Offre _$OffreFromJson(Map<String, dynamic> json) => Offre(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String?,
      mission: json['mission'] as String?,
      profil: json['profil'] as String?,
      contractType: json['contractType'] as String?,
      reference: json['reference'] as String?,
      dateDebut: json['dateDebut'] as String?,
      isHandicap: json['isHandicap'] as bool?,
      dureeContrat: json['dureeContrat'] as String?,
      statut: (json['statut'] as num?)?.toInt(),
      company: Company.fromJson(json['company'] as Map<String, dynamic>),
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      salaryRange: json['salaryRange'] as String?,
      sector: json['sector'] as String?,
      dateSoumission: json['dateSoumission'] as String?,
    );

Map<String, dynamic> _$OffreToJson(Offre instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'mission': instance.mission,
      'profil': instance.profil,
      'contractType': instance.contractType,
      'reference': instance.reference,
      'dateDebut': instance.dateDebut,
      'isHandicap': instance.isHandicap,
      'dureeContrat': instance.dureeContrat,
      'statut': instance.statut,
      'company': instance.company,
      'location': instance.location,
      'salaryRange': instance.salaryRange,
      'sector': instance.sector,
      'dateSoumission': instance.dateSoumission,
    };
