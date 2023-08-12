import 'package:cli/cli.dart';
import 'package:pub_semver/pub_semver.dart';

class UseCommand extends Command {
  const UseCommand();
}

class UseCommandRunner implements CommandRunner {
  const UseCommandRunner({
    this.version,
  });

  final Version? version;

  @override
  Future<ExitStatus> run() {
    // TODO: implement run
    throw UnimplementedError();
  }
}
