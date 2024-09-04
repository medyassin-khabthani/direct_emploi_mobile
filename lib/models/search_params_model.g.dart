// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_params_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchParams _$SearchParamsFromJson(Map<String, dynamic> json) => SearchParams(
      q: json['q'] as String?,
      localisation: json['localisation'] as String?,
      contrat: json['contrat'] as String?,
      offset: json['offset'] as String,
      limit: json['limit'] as String,
    );

Map<String, dynamic> _$SearchParamsToJson(SearchParams instance) =>
    <String, dynamic>{
      'q': instance.q,
      'localisation': instance.localisation,
      'contrat': instance.contrat,
      'offset': instance.offset,
      'limit': instance.limit,
    };
