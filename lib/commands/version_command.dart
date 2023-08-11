import 'package:cli/cli.dart';

class VersionCommand extends Command {
  const VersionCommand();
}

class VersionCommandRunner implements CommandRunner {
  const VersionCommandRunner();

  @override
  Future<ExitCode> run() {
    // TODO: implement run
    throw UnimplementedError();
  }
}
