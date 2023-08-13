import 'package:collection/collection.dart';

sealed class Option<V> {
  const Option({
    required this.help,
  });

  final String help;

  /// Throws [AssertionError].
  void checkFields();

  /// Throws [FormatException].
  V? parse(List<String> args);
}

base class KeyOption extends Option<bool> {
  KeyOption({
    required this.key,
    required this.abbr,
    required super.help,
  });

  final String key;
  final String? abbr;

  @override
  void checkFields() {
    final keyRegex = RegExp(r'^[a-zA-Z]{2,}$');
    assert(
      keyRegex.hasMatch(key),
      'Key must be at least 2 alphabetic characters.',
    );

    final abbrRegex = RegExp(r'^[a-zA-Z]$');
    assert(
      abbr == null || abbrRegex.hasMatch(abbr!),
      'Abbr must be null or one of alphabet.',
    );
  }

  @override
  bool parse(List<String> args) {
    final RegExp regex;
    if (abbr == null) {
      regex = RegExp('^--$key\$');
    } else {
      regex = RegExp('^--$key|-$abbr\$');
    }
    return args.any((arg) {
      final match = regex.firstMatch(arg);
      final hasMatch = match != null;
      if (hasMatch) {
        args.remove(arg);
      }
      return hasMatch;
    });
  }
}

base class KeyValueOption<V> extends Option<V> {
  const KeyValueOption({
    required this.key,
    required this.abbr,
    required this.defaultsTo,
    required this.mandatory,
    required this.parseValue,
    required super.help,
  });

  final String key;
  final String? abbr;
  final V? defaultsTo;
  final bool mandatory;
  final V? Function(String) parseValue;

  @override
  void checkFields() {
    final keyRegex = RegExp(r'^[a-zA-Z]{2,}$');
    assert(
      keyRegex.hasMatch(key),
      'Key must be at least 2 alphabetic characters.',
    );

    final abbrRegex = RegExp(r'^[a-zA-Z]$');
    assert(
      abbr == null || abbrRegex.hasMatch(abbr!),
      'Abbr must be null or one of alphabet.',
    );

    assert(
      !mandatory || defaultsTo == null,
      'The option $key cannot be mandatory and have a default value.',
    );
  }

  @override
  V? parse(List<String> args) {
    const nameValueKey = 'valueKey';
    const nameValueAbbr = 'valueAbbr';

    final RegExp regex;
    if (abbr == null) {
      regex = RegExp('^--$key=(?<$nameValueKey>.+)\$');
    } else {
      regex = RegExp(
        '^--$key=(?<$nameValueKey>.+)|-$abbr=(?<$nameValueAbbr>.+)\$',
      );
    }

    final arg = args.firstWhereOrNull(regex.hasMatch);
    if (arg == null) {
      if (mandatory) {
        throw FormatException('Option $key is mandatory.');
      }
      return null;
    }

    // Already checked above for a match.
    final match = regex.firstMatch(arg)!;
    final valueKey = match.namedGroup(nameValueKey);
    final valueAbbr = match.namedGroup(nameValueAbbr);

    // Either valueKey or valueAbbr is not null.
    final value = valueKey ?? valueAbbr!;
    return parseValue(value) ?? defaultsTo;
  }
}

base class ValueOption<V> extends Option<V> {
  const ValueOption({
    required this.name,
    required this.defaultsTo,
    required this.mandatory,
    required this.parseValue,
    required super.help,
  });

  final String name;
  final V? defaultsTo;
  final bool mandatory;
  final V? Function(String) parseValue;

  @override
  void checkFields() {
    assert(
      !mandatory || defaultsTo == null,
      'The option $name cannot be mandatory and have a default value.',
    );
  }

  @override
  V? parse(List<String> args) {
    for (final arg in args) {
      final V? value;
      try {
        value = parseValue(arg);
      } on FormatException {
        continue;
      }
      if (value != null) {
        return value;
      }
    }
    if (mandatory) {
      throw FormatException('Option $name is mandatory.');
    }
    return defaultsTo;
  }
}
