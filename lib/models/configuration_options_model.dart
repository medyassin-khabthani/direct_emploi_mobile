import 'package:json_annotation/json_annotation.dart';

part 'configuration_options_model.g.dart';

@JsonSerializable()
class ConfigurationOptions {
  final String? based;
  final String? cvFile;
  final String? q;
  final String? localisation;

  ConfigurationOptions({
    this.based,
    this.cvFile,
    this.q,
    this.localisation,
  });

  factory ConfigurationOptions.fromJson(Map<String, dynamic> json) => _$ConfigurationOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigurationOptionsToJson(this);

}
