import 'dart:io';

import 'package:cli/cli.dart' show Cli, ExitStatus, UsageException;
import 'package:dvm/commands/help_command.dart';
import 'package:dvm/commands/install_command.dart';
import 'package:dvm/commands/releases_command.dart';
import 'package:dvm/commands/use_command.dart';
import 'package:dvm/commands/version_command.dart';
import 'package:dvm/gen/package_info.g.dart';
import 'package:dvm/utils/logger.dart';

class DvmCli extends Cli {
  DvmCli({
    super.packageInfo = packageInfo,
    super.commands = const [
      VersionCommand(),
      HelpCommand(),
      ReleasesCommand(),
      InstallCommand(),
      UseCommand(),
    ],
  });

  Future<void> run(Iterable<String> args) async {
    final exitStatus = await _run(args);
    return exitStatus.flushThenExit();
  }

  Future<ExitStatus> _run(Iterable<String> args) async {
    try {
      final commandRunner = parse(args);
      return commandRunner.run();
    } on UsageException catch (e) {
      logger
        ..spacer()
        ..warning(e.message)
        ..spacer()
        ..info(e.usage)
        ..spacer();
      return ExitStatus.usage;
    } on Exception catch (e) {
      logger.error(e.toString());
      return ExitStatus.errors;
    }
  }
}

extension _FlushThenExit on ExitStatus {
  Future<void> flushThenExit() async => Future.wait([
        stdout.close(),
        stderr.close(),
      ]).then((_) => exit(code));
}
