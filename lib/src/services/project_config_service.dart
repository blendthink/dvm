import 'dart:convert';

import 'package:dvm/src/models/dart_sdk_version.dart';
import 'package:dvm/src/models/project_config.dart';
import 'package:file/file.dart' show Directory, File, Link;

class ProjectConfigService {
  ProjectConfigService({
    required Directory projectConfigDir,
    required Directory cacheDir,
    JsonEncoder prettyEncoder = const JsonEncoder.withIndent('  '),
  })  : _projectConfigDir = projectConfigDir,
        _cacheDir = cacheDir,
        _prettyEncoder = prettyEncoder;

  final Directory _projectConfigDir;
  final Directory _cacheDir;
  final JsonEncoder _prettyEncoder;

  File get _configFile => _projectConfigDir.childFile('config.json');

  File get _ignoreFile => _projectConfigDir.childFile('.gitignore');

  Link get _sdkLink => _projectConfigDir.childLink('dart_sdk');

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
    await updateSdkLink(config.version);
  }

  Future<void> updateSdkLink(DartSdkVersion version) async {
    final channel = version.channel;
    final versionName = version.toString();

    final targetPath =
        _cacheDir.childDirectory('${channel.name}/$versionName').path;
    if (_sdkLink.existsSync()) {
      await _sdkLink.update(targetPath);
    } else {
      await _sdkLink.create(targetPath);
    }
  }
}
