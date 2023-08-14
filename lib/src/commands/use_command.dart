import 'package:cli/cli.dart';
import 'package:dvm/src/options/version_option.dart';
import 'package:pub_semver/pub_semver.dart';

class UseCommand extends Command {
  const UseCommand({
    this.versionOption = const VersionOption(),
  });

  final VersionOption versionOption;

  @override
  CommandRunner parse(List<String> args) {
    final version = versionOption.parse(args);
    return UseCommandRunner(
      version: version,
    );
  }
}

class UseCommandRunner implements CommandRunner {
  const UseCommandRunner({
    required this.version,
  });

  final Version? version;

  @override
  Future<ExitStatus> run() {
    final Version version;
    if (this.version == null) {
      // TODO: Find version by ${Directory.current}/dvm_config.json

      // TODO: If not found, then throw error
    }

    // TODO: Check version is installed. If not install, then install.

    // TODO: Update config file

    // TODO: implement run
    throw UnimplementedError();
  }
}
