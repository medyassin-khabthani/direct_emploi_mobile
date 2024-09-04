// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedSearch _$SavedSearchFromJson(Map<String, dynamic> json) => SavedSearch(
      id: json['id'] as String,
      userId: json['userId'] as String,
      searchParams:
          SearchParams.fromJson(json['searchParams'] as Map<String, dynamic>),
      savedAt: json['savedAt'] as String,
    );

Map<String, dynamic> _$SavedSearchToJson(SavedSearch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'searchParams': instance.searchParams,
      'savedAt': instance.savedAt,
    };
