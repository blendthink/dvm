import 'package:cli/cli.dart';

class InstallCommand extends Command {
  const InstallCommand();
}

class InstallCommandRunner implements CommandRunner {
  const InstallCommandRunner();

  @override
  Future<ExitCode> run() {
    // TODO: implement run
    throw UnimplementedError();
  }
}
