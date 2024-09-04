// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration_options_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigurationOptions _$ConfigurationOptionsFromJson(
        Map<String, dynamic> json) =>
    ConfigurationOptions(
      based: json['based'] as String?,
      cvFile: json['cvFile'] as String?,
      q: json['q'] as String?,
      localisation: json['localisation'] as String?,
    );

Map<String, dynamic> _$ConfigurationOptionsToJson(
        ConfigurationOptions instance) =>
    <String, dynamic>{
      'based': instance.based,
      'cvFile': instance.cvFile,
      'q': instance.q,
      'localisation': instance.localisation,
    };
