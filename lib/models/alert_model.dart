import 'package:json_annotation/json_annotation.dart';


part 'alert_model.g.dart';

@JsonSerializable()
class Alert {
  final int id;
  final String libelle;
  final int? experience;
  final int actif;
  final int? typeContrat;
  final int? secteurActivite;
  final int? region;
  final int? formation;
  final int? remuneration;
  final String? motsCles;
  final int? handicap;
  final int isRss;
  final String? datePassageCron;
  final int? departement;
  final String? dateDernierEnvoi;
  final int userId;

  Alert({
    required this.id,
    required this.libelle,
    this.experience,
    required this.actif,
    this.typeContrat,
    this.secteurActivite,
    this.region,
    this.formation,
    this.remuneration,
    this.motsCles,
    this.handicap,
    required this.isRss,
    this.datePassageCron,
    this.departement,
    this.dateDernierEnvoi,
    required this.userId,
  });

  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);

  Map<String, dynamic> toJson() => _$AlertToJson(this);
}
