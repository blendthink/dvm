import 'package:dvm/src/extensions/file_system_ext.dart';
import 'package:dvm/src/models/dart_sdk_version.dart';
import 'package:dvm/src/models/project_config.dart';
import 'package:dvm/src/services/project_config_service.dart';
import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:test/test.dart';

void main() async {
  late FileSystem fileSystem;
  late File configFile;
  late File ignoreFile;
  late Link sdkLink;
  late Directory cacheDir;

  late ProjectConfigService service;

  setUp(() {
    fileSystem = MemoryFileSystem();
    configFile = fileSystem.configFile;
    ignoreFile = fileSystem.ignoreFile;
    sdkLink = fileSystem.sdkLink;
    cacheDir = fileSystem.cacheDir;

    service = ProjectConfigService(
      configFile: configFile,
      ignoreFile: ignoreFile,
      sdkLink: sdkLink,
      cacheDir: cacheDir,
    );
  });

  group('findConfig', () {
    test('null', () {
      // Arrange
      expect(configFile.existsSync(), isFalse);

      // Act
      final actual = service.findConfig();

      // Assert
      expect(actual, isNull);
    });
    test('stable', () {
      // Arrange
      const version = '3.0.7';
      const contents = '''
{
  "dartSdkVersion": "$version"
}
''';
      configFile
        ..createSync(recursive: true)
        ..writeAsStringSync(contents);

      // Act
      final actual = service.findConfig();

      // Assert
      expect(actual?.version.toString(), version);
    });
    test('dev', () {
      // Arrange
      const version = '3.2.0-36.0.dev';
      const contents = '''
{
  "dartSdkVersion": "$version"
}
''';
      configFile
        ..createSync(recursive: true)
        ..writeAsStringSync(contents);

      // Act
      final actual = service.findConfig();

      // Assert
      expect(actual?.version.toString(), version);
    });
  });

  group('updateConfig', () {
    test('stable', () async {
      // Arrange
      final version = DartSdkVersion.fromString('3.0.7');
      final config = ProjectConfig(version: version);

      // Act
      await service.updateConfig(config);

      // Assert
      expect(configFile.existsSync(), isTrue);
      final configContents = configFile.readAsStringSync();
      expect(configContents, contains('"dartSdkVersion": "3.0.7"'));

      expect(ignoreFile.existsSync(), isTrue);
      final ignoreContents = ignoreFile.readAsStringSync();
      expect(ignoreContents, contains('dart_sdk'));

      expect(sdkLink.existsSync(), isTrue);
      final targetLink = sdkLink.targetSync();
      expect(targetLink, endsWith('/.dvm/versions/stable/3.0.7'));
    });
    test('dev', () async {
      // Arrange
      final version = DartSdkVersion.fromString('3.2.0-36.0.dev');
      final config = ProjectConfig(version: version);

      // Act
      await service.updateConfig(config);

      // Assert
      expect(configFile.existsSync(), isTrue);
      final configContents = configFile.readAsStringSync();
      expect(configContents, contains('"dartSdkVersion": "3.2.0-36.0.dev"'));

      expect(ignoreFile.existsSync(), isTrue);
      final ignoreContents = ignoreFile.readAsStringSync();
      expect(ignoreContents, contains('dart_sdk'));

      expect(sdkLink.existsSync(), isTrue);
      final targetLink = sdkLink.targetSync();
      expect(targetLink, endsWith('/.dvm/versions/dev/3.2.0-36.0.dev'));
    });
  });
}
