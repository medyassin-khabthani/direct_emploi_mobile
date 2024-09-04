// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Configuration _$ConfigurationFromJson(Map<String, dynamic> json) =>
    Configuration(
      id: json['id'] as String,
      userId: json['userId'] as String,
      configuration: ConfigurationOptions.fromJson(
          json['configuration'] as Map<String, dynamic>),
      savedAt: json['savedAt'] as String,
    );

Map<String, dynamic> _$ConfigurationToJson(Configuration instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'configuration': instance.configuration,
      'savedAt': instance.savedAt,
    };
