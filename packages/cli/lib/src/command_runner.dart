import 'package:cli/src/data/exit_status.dart';

abstract interface class CommandRunner {
  Future<ExitStatus> run();
}
