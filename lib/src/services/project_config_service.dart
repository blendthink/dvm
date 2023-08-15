import 'dart:convert';

import 'package:dvm/src/models/dart_sdk_version.dart';
import 'package:dvm/src/models/project_config.dart';
import 'package:file/file.dart' show Directory, File, Link;

class ProjectConfigService {
  ProjectConfigService({
    required File configFile,
    required File ignoreFile,
    required Link sdkLink,
    required Directory cacheDir,
    JsonEncoder prettyEncoder = const JsonEncoder.withIndent('  '),
  })  : _configFile = configFile,
        _ignoreFile = ignoreFile,
        _sdkLink = sdkLink,
        _cacheDir = cacheDir,
        _prettyEncoder = prettyEncoder;

  final File _configFile;
  final File _ignoreFile;
  final Link _sdkLink;
  final Directory _cacheDir;
  final JsonEncoder _prettyEncoder;

  ProjectConfig? findConfig() {
    if (!_configFile.existsSync()) {
      return null;
    }
    final jsonString = _configFile.readAsStringSync();
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return ProjectConfig.fromJson(json);
  }

  Future<void> updateConfig(ProjectConfig config) async {
    if (!_configFile.existsSync()) {
      await _configFile.create(recursive: true);
    }
    final json = config.toJson();
    final jsonString = _prettyEncoder.convert(json);
    await _configFile.writeAsString('$jsonString\n');

    if (!_ignoreFile.existsSync()) {
      await _ignoreFile.create(recursive: true);
      await _ignoreFile.writeAsString('dart_sdk\n');
    }
    await _updateSdkLink(config.version);
  }

  Future<void> _updateSdkLink(DartSdkVersion version) async {
    final channel = version.channel;
    final targetPath =
        _cacheDir.childDirectory('${channel.name}/$version').path;
    if (_sdkLink.existsSync()) {
      await _sdkLink.update(targetPath);
    } else {
      await _sdkLink.create(targetPath);
    }
  }
}
