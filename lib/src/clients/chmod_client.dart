import 'dart:io' show Process, ProcessException, ProcessResult;

import 'package:file/file.dart';

const _executable = 'chmod';

class ChmodClient {
  const ChmodClient();

  Future<void> grantExecPermission(File file) async {
    final args = ['+x', file.path];
    final result = await Process.run(_executable, args);

    final exitCode = result.exitCode;
    final stderr = result.stderr as String;

    if (exitCode != 0) {
      throw ProcessException(_executable, args, stderr, exitCode);
    }
  }
}
