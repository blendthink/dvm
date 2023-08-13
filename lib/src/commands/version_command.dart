import 'package:cli/cli.dart';

class VersionCommand extends Command {
  const VersionCommand();

  @override
  CommandRunner parse(List<String> args) {
    return const VersionCommandRunner();
  }
}

class VersionCommandRunner implements CommandRunner {
  const VersionCommandRunner();

  @override
  Future<ExitStatus> run() {
    // TODO: implement run
    throw UnimplementedError();
  }
}
