import 'package:cli/cli.dart';

class HelpCommand extends Command {
  const HelpCommand();
}

class HelpCommandRunner implements CommandRunner {
  const HelpCommandRunner();

  @override
  Future<ExitCode> run() {
    // TODO: implement run
    throw UnimplementedError();
  }
}
