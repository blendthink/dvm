import 'package:cli/cli.dart' show Cli, ExitStatus, UsageException;
import 'package:dvm/commands/help_command.dart';
import 'package:dvm/commands/install_command.dart';
import 'package:dvm/commands/releases_command.dart';
import 'package:dvm/commands/use_command.dart';
import 'package:dvm/commands/version_command.dart';
import 'package:dvm/gen/package_info.g.dart';
import 'package:dvm/utils/logger.dart';

Future<ExitStatus> run(Iterable<String> args) async {
  final cli = Cli(
    packageInfo: packageInfo,
    commands: const [
      VersionCommand(),
      HelpCommand(),
      ReleasesCommand(),
      InstallCommand(),
      UseCommand(),
    ],
  );

  try {
    final commandRunner = cli.parse(args);
    return commandRunner.run();
  } on UsageException catch (e) {
    Logger.spacer();
    Logger.warning(e.message);
    Logger.spacer();
    Logger.info(e.usage);
    Logger.spacer();
    return ExitStatus.usage;
  } on Exception catch (e) {
    Logger.error(e.toString());
    return ExitStatus.errors;
  }
}
