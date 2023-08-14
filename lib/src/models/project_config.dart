import 'package:dvm/src/models/dart_sdk_version.dart';

class ProjectConfig {
  const ProjectConfig({
    required this.version,
  });

  factory ProjectConfig.fromJson(Map<String, dynamic> json) => ProjectConfig(
        version: DartSdkVersion.fromString(json['dartSdkVersion'] as String),
      );

  final DartSdkVersion version;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'dartSdkVersion': version.toString(),
      };
}
