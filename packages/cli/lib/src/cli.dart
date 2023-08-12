import 'dart:collection';

import 'package:cli/cli.dart';
import 'package:cli/src/extensions/iterable_extensions.dart';

abstract class Cli {
  Cli({
    required PackageInfo packageInfo,
    required List<Command> commands,
  })  : _packageInfo = packageInfo,
        _commands = UnmodifiableListView(commands) {
    final duplicatedCommand = _commands.firstDuplicatedWhereOrNull((c) => true);
    if (duplicatedCommand != null) {
      throw ArgumentError('Duplicate command "$duplicatedCommand".');
    }
  }

  final PackageInfo _packageInfo;
  final List<Command> _commands;

  CommandRunner parse(Queue<String> args) {
    if (args.isEmpty) {
      throw const UsageException(
        'No command specified',
        Usage(),
      );
    }

    final commandName = args.removeFirst();
    final command = _commands.firstWhere(
      (c) => true, // c.name == commandName,
      orElse: () => throw UsageException(
        'Could not find a command named "$commandName".',
        const Usage(),
      ),
    );

    // TODO: implement
    throw UnimplementedError();
  }
}
