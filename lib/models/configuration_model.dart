import 'package:direct_emploi/models/search_params_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'configuration_options_model.dart';

part 'configuration_model.g.dart';

@JsonSerializable()
class Configuration {
  final String id;
  final String userId;
  final ConfigurationOptions configuration;
  final String savedAt;

  Configuration({
    required this.id,
    required this.userId,
    required this.configuration,
    required this.savedAt,
  });

  factory Configuration.fromJson(Map<String, dynamic> json) => _$ConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigurationToJson(this);

}
