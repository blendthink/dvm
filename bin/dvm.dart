import 'dart:io';

import 'package:dvm/dvm.dart' as dvm;

void main(List<String> arguments) async {
  final exitStatus = await dvm.run(arguments);
  await Future.wait([stdout.close(), stderr.close()]).then(
    (_) => exit(exitStatus.code),
  );
}
