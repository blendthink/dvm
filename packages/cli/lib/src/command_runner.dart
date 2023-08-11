import 'package:cli/src/data/exit_code.dart';

abstract interface class CommandRunner {
  Future<ExitCode> run();
}
