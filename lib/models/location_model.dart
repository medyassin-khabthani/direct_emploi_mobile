import 'package:json_annotation/json_annotation.dart';

part 'location_model.g.dart';

@JsonSerializable()
class Location {
  final String? city;
  final String? department;
  final String? region;
  final String? postalCode;
  final String? country;

  Location({
     this.city,
     this.department,
     this.region,
     this.postalCode,
     this.country,
  });

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
