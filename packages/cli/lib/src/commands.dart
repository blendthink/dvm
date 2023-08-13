import 'package:cli/cli.dart';

abstract class Command {
  const Command();

  CommandRunner parse(List<String> args);
}
