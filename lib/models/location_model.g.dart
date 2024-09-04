// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      city: json['city'] as String?,
      department: json['department'] as String?,
      region: json['region'] as String?,
      postalCode: json['postalCode'] as String?,
      country: json['country'] as String?,
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'city': instance.city,
      'department': instance.department,
      'region': instance.region,
      'postalCode': instance.postalCode,
      'country': instance.country,
    };
