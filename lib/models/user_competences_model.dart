import 'package:json_annotation/json_annotation.dart';

part 'user_competences_model.g.dart';

@JsonSerializable()
class UserCompetences {
  String? competences;
  int? idChoixLangue1;
  int? idNiveauLangue1;
  int? idChoixLangue2;
  int? idNiveauLangue2;
  int? permisB;
  int? isProfileVisible;

  UserCompetences({
    this.competences,
    this.idChoixLangue1,
    this.idNiveauLangue1,
    this.idChoixLangue2,
    this.idNiveauLangue2,
    this.permisB,
    this.isProfileVisible,
  });

  factory UserCompetences.fromJson(Map<String, dynamic> json) => _$UserCompetencesFromJson(json);

  Map<String, dynamic> toJson() => _$UserCompetencesToJson(this);
}