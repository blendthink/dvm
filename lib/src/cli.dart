import 'package:cli/cli.dart';
import 'package:dvm/src/commands/commands.dart';
import 'package:dvm/src/logger.dart';
import 'package:dvm/src/package_info.dart';

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

  Future<ExitStatus> run(Iterable<String> args) async {
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
