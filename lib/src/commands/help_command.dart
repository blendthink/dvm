import 'package:cli/cli.dart';

class HelpCommand extends Command {
  const HelpCommand();

  @override
  CommandRunner parse(List<String> args) {
    return const HelpCommandRunner();
  }
}

class HelpCommandRunner implements CommandRunner {
  const HelpCommandRunner();

  @override
  Future<ExitStatus> run() {
    // TODO: implement run
    throw UnimplementedError();
  }
}
