import 'package:json_annotation/json_annotation.dart';

part 'user_situation_model.g.dart';

@JsonSerializable()
class UserSituation {
  int? idSecteurActivite;
  int? idMetier;
  int? idTypeFormation;
  int? idEtablissement;
  String? nomDiplome;
  String? anneDiplome;
  String? posteActuel;
  int? idSecteurActivitePoste;
  int? idFourchetteRemuneration;
  int? idSituationActivite;
  int? idSituationExperience;
  int? idDisponibilite;
  int? idMobilite;

  UserSituation({
    this.idSecteurActivite,
    this.idMetier,
    this.idTypeFormation,
    this.idEtablissement,
    this.nomDiplome,
    this.anneDiplome,
    this.posteActuel,
    this.idSecteurActivitePoste,
    this.idFourchetteRemuneration,
    this.idSituationActivite,
    this.idSituationExperience,
    this.idDisponibilite,
    this.idMobilite,
  });

  factory UserSituation.fromJson(Map<String, dynamic> json) => _$UserSituationFromJson(json);

  Map<String, dynamic> toJson() => _$UserSituationToJson(this);

}