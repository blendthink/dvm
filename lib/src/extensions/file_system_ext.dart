import 'dart:io';

import 'package:file/file.dart';

extension FileSystemExt on FileSystem {
  Directory get projectConfigDir => currentDirectory.childDirectory('.dvm');

  File get configFile => projectConfigDir.childFile('config.json');

  File get ignoreFile => projectConfigDir.childFile('.gitignore');

  Link get sdkLink => projectConfigDir.childLink('dart_sdk');

  Directory get cacheDir => _homeDir.childDirectory('.dvm/versions');

  Directory get _homeDir {
    if (!Platform.isLinux && !Platform.isMacOS) {
      throw UnsupportedError(
        'homeDirectory is not supported on ${Platform.operatingSystem}.',
      );
    }
    final path = Platform.environment['HOME'] ??
        (throw StateError('HOME not defined in environment.'));
    return directory(path);
  }
}
