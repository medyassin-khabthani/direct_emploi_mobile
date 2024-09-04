import 'package:json_annotation/json_annotation.dart';
import 'company_model.dart';
import 'location_model.dart';

part 'offre_model.g.dart';

@JsonSerializable()
class Offre {
  final int id;
  final String? title;
  final String? mission;
  final String? profil;
  final String? contractType;
  final String? reference;
  final String? dateDebut;
  final bool? isHandicap;
  final String? dureeContrat;
  final int? statut;
  final Company company;
  final Location location;
  final String? salaryRange;
  final String? sector;
  final String? dateSoumission;

  Offre({
    required this.id,
     this.title,
     this.mission,
     this.profil,
     this.contractType,
     this.reference,
     this.dateDebut,
     this.isHandicap,
     this.dureeContrat,
      this.statut,
    required this.company,
    required this.location,
     this.salaryRange,
     this.sector,
     this.dateSoumission,
  });

  factory Offre.fromJson(Map<String, dynamic> json) => _$OffreFromJson(json);

  Map<String, dynamic> toJson() => _$OffreToJson(this);

  static List<Offre> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Offre.fromJson(json)).toList();
  }
}
