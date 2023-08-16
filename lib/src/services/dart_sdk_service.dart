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

  Future<List<DartSdkVersion>> getDartSdkVersions() async {
    // final releases = await _client.get();
    // return releases.versions;
    throw UnimplementedError();
  }

  Future<void> downloadDartSdk({
    required DartSdkVersion version,
  }) async {
    final channel = version.channel;
    final targetDir = _cacheDir.childDirectory('${channel.name}/$version');

    if (targetDir.existsSync()) {
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

    if (Platform.isLinux || Platform.isMacOS) {
      final dartBin = targetDir.childFile('dart-sdk/bin/dart');
      await _chmodClient.grantExecPermission(dartBin);
    }
  }
}
