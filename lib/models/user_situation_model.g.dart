// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_situation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSituation _$UserSituationFromJson(Map<String, dynamic> json) =>
    UserSituation(
      idSecteurActivite: (json['idSecteurActivite'] as num?)?.toInt(),
      idMetier: (json['idMetier'] as num?)?.toInt(),
      idTypeFormation: (json['idTypeFormation'] as num?)?.toInt(),
      idEtablissement: (json['idEtablissement'] as num?)?.toInt(),
      nomDiplome: json['nomDiplome'] as String?,
      anneDiplome: json['anneDiplome'] as String?,
      posteActuel: json['posteActuel'] as String?,
      idSecteurActivitePoste: (json['idSecteurActivitePoste'] as num?)?.toInt(),
      idFourchetteRemuneration:
          (json['idFourchetteRemuneration'] as num?)?.toInt(),
      idSituationActivite: (json['idSituationActivite'] as num?)?.toInt(),
      idSituationExperience: (json['idSituationExperience'] as num?)?.toInt(),
      idDisponibilite: (json['idDisponibilite'] as num?)?.toInt(),
      idMobilite: (json['idMobilite'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserSituationToJson(UserSituation instance) =>
    <String, dynamic>{
      'idSecteurActivite': instance.idSecteurActivite,
      'idMetier': instance.idMetier,
      'idTypeFormation': instance.idTypeFormation,
      'idEtablissement': instance.idEtablissement,
      'nomDiplome': instance.nomDiplome,
      'anneDiplome': instance.anneDiplome,
      'posteActuel': instance.posteActuel,
      'idSecteurActivitePoste': instance.idSecteurActivitePoste,
      'idFourchetteRemuneration': instance.idFourchetteRemuneration,
      'idSituationActivite': instance.idSituationActivite,
      'idSituationExperience': instance.idSituationExperience,
      'idDisponibilite': instance.idDisponibilite,
      'idMobilite': instance.idMobilite,
    };
