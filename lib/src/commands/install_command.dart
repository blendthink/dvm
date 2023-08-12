import 'package:cli/cli.dart';

class InstallCommand extends Command {
  const InstallCommand();
}

class InstallCommandRunner implements CommandRunner {
  const InstallCommandRunner();

  @override
  Future<ExitStatus> run() {
    // TODO: implement run
    throw UnimplementedError();
  }
}
