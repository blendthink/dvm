import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dvm/src/clients/chmod_client.dart';
import 'package:dvm/src/extensions/abi_ext.dart';
import 'package:dvm/src/models/dart_sdk_version.dart';
import 'package:file/file.dart';
import 'package:http/http.dart';

class DartSdkService {
  const DartSdkService({
    required Client client,
    required ChmodClient chmodClient,
    required Abi abi,
    required ZipDecoder zipDecoder,
    required Directory cacheDir,
  })  : _client = client,
        _chmodClient = chmodClient,
        _abi = abi,
        _zipDecoder = zipDecoder,
        _cacheDir = cacheDir;

  final Client _client;
  final ChmodClient _chmodClient;
  final Abi _abi;
  final ZipDecoder _zipDecoder;
  final Directory _cacheDir;

  Future<List<DartSdkVersion>> getDartSdkVersions(
    DartSdkChannel channel,
  ) async {
    final url = 'https://www.googleapis.com/storage/v1/b/dart-archive/o/'
        '?prefix=channels/${channel.name}/release/&delimiter=/';

    final response = await _client.get(Uri.parse(url));
    if (response.statusCode case < 200 && >= 300) {
      throw Exception('Could not fetch Dart SDK versions');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final prefixes = json['prefixes'] as List<dynamic>;

    final versions = prefixes
        .map((prefix) => _findVersionOrNull(channel, prefix as String))
        .nonNulls
        .toList();

    return versions;
  }

  /// prefix の中にバージョン文字列が含まれていれば、そのバージョンを返す。
  /// そうでなければ null を返す。
  DartSdkVersion? _findVersionOrNull(DartSdkChannel channel, String prefix) {
    const nameVersion = 'version';

    final regex = RegExp(
      '''^channels/${channel.name}/release/(?<$nameVersion>\\d+\\.\\d+\\.\\d+(-\\d+\\.\\d+\\.beta|dev)?)/\$''',
    );

    final match = regex.firstMatch(prefix);
    if (match == null) {
      return null;
    }

    final version = match.namedGroup(nameVersion)!;
    return DartSdkVersion.fromString(version);
  }

  Future<void> downloadDartSdk({
    required DartSdkVersion version,
  }) async {
    final channel = version.channel;
    final targetDir = _cacheDir.childDirectory(channel.name);
    final versionDir = targetDir.childDirectory(version.toString());

    if (versionDir.existsSync()) {
      return;
    }

    final (os: os, architecure: arch) = _abi.osAndArch;
    final url = 'https://storage.googleapis.com/dart-archive/'
        'channels/${channel.name}/release/$version/'
        'sdk/dartsdk-$os-$arch-release.zip';

    final response = await _client.get(Uri.parse(url));
    if (response.statusCode case < 200 && >= 300) {
      throw Exception('Could not download Dart SDK');
    }

    final bytes = response.bodyBytes;
    final archive = _zipDecoder.decodeBytes(bytes);
    extractArchiveToDisk(archive, targetDir.path);

    final sdkDir = targetDir.childDirectory('dart-sdk');
    if (!sdkDir.existsSync()) {
      throw Exception('Could not find Dart SDK');
    }
    sdkDir.renameSync(versionDir.path);

    if (Platform.isLinux || Platform.isMacOS) {
      final dartBin = versionDir.childFile('bin/dart');
      if (!dartBin.existsSync()) {
        throw Exception('Could not find Dart binary');
      }
      await _chmodClient.grantExecPermission(dartBin);
    }
  }
}
