import 'package:json_annotation/json_annotation.dart';

part 'cv_model.g.dart';

@JsonSerializable()
class Cv {
  final int id;
  final String titre;
  final String nomFichierCvOriginal;
  final String nomFichierCvStockage;
  final int isVisible;
  final String dateCreation;
  final String dateModification;

  Cv({
    required this.id,
    required this.titre,
    required this.nomFichierCvOriginal,
    required this.nomFichierCvStockage,
    required this.isVisible,
    required this.dateCreation,
    required this.dateModification,
  });

  factory Cv.fromJson(Map<String, dynamic> json) => _$CvFromJson(json);

  Map<String, dynamic> toJson() => _$CvToJson(this);

}
