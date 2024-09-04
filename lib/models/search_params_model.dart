import 'package:json_annotation/json_annotation.dart';

part 'search_params_model.g.dart';

@JsonSerializable()
class SearchParams {
  final String? q;
  final String? localisation;
  final String? contrat;
  final String offset;
  final String limit;

  SearchParams({
    this.q,
    this.localisation,
    this.contrat,
    required this.offset,
    required this.limit
  });

  factory SearchParams.fromJson(Map<String, dynamic> json) => _$SearchParamsFromJson(json);

  Map<String, dynamic> toJson() => _$SearchParamsToJson(this);

  static List<SearchParams> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SearchParams.fromJson(json)).toList();
  }
}
