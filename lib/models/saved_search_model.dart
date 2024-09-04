import 'package:direct_emploi/models/search_params_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'saved_search_model.g.dart';

@JsonSerializable()
class SavedSearch {
  final String id;
  final String userId;
  final SearchParams searchParams;
  final String savedAt;

  SavedSearch({
    required this.id,
    required this.userId,
    required this.searchParams,
    required this.savedAt,
  });

  factory SavedSearch.fromJson(Map<String, dynamic> json) => _$SavedSearchFromJson(json);

  Map<String, dynamic> toJson() => _$SavedSearchToJson(this);

  static List<SavedSearch> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SavedSearch.fromJson(json)).toList();
  }
}
