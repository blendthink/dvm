import 'dart:io';

import 'package:dvm/dvm.dart';

Future<void> main(List<String> args) async {
  final status = await DvmCli().run(args);
  return Future.wait([
    stdout.close(),
    stderr.close(),
  ]).then((_) => exit(status.code));
}
