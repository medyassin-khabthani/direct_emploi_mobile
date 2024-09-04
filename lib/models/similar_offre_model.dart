import 'package:json_annotation/json_annotation.dart';

part 'similar_offre_model.g.dart';

@JsonSerializable()
class SimilarOffre {
  final int id;
  final String title;
  final String mission;
  final String reference;
  final String ville;
  final String contractType;
  final String logo;
  final String companyName;
  final String dateSoumission;
  bool applied;  // New property to track application status

  SimilarOffre({
    required this.id,
    required this.title,
    required this.mission,
    required this.contractType,
    required this.reference,
    required this.logo,
    required this.ville,
    required this.companyName,
    required this.dateSoumission,
    this.applied = false, // Initialize as false
  });

  factory SimilarOffre.fromJson(Map<String, dynamic> json) => _$SimilarOffreFromJson(json);

  Map<String, dynamic> toJson() => _$SimilarOffreToJson(this);

  static List<SimilarOffre> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SimilarOffre.fromJson(json)).toList();
  }
}
