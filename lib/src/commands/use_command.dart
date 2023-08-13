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

  final Version version;

  @override
  Future<ExitStatus> run() {
    // TODO: implement run
    throw UnimplementedError();
  }
}
