import 'package:cli/cli.dart';
import 'package:cli/src/extensions/iterable_extensions.dart';
import 'package:collection/collection.dart';

class Cli {
  Cli({
    required PackageInfo packageInfo,
    required List<Command> commands,
  })  : _packageInfo = packageInfo,
        _commands = UnmodifiableListView(commands) {
    final duplicatedCommand = _commands.firstDuplicatedWhereOrNull((c) => true);
    if (duplicatedCommand != null) {
      throw const UsageException(
        'message',
        Usage(),
      );
    }
  }

  final PackageInfo _packageInfo;
  final List<Command> _commands;

  CommandRunner parse(Iterable<String> args) {
    if (args.isEmpty) {
      throw const UsageException(
        'No command specified',
        Usage(),
      );
    }

    final command = _commands.firstWhereOrNull(
      (c) => true, // c.name == args.first,
    );

    if (command == null) {
      throw UsageException(
        'Could not find a command named "${args.first}".',
        const Usage(),
      );
    }

    // TODO: implement
    throw UnimplementedError();
  }
}
