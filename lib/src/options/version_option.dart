import 'package:cli/cli.dart';
import 'package:pub_semver/pub_semver.dart';

final class VersionOption extends ValueOption<Version> {
  const VersionOption()
      : super(
          name: 'version',
          defaultsTo: null,
          mandatory: true,
          parseValue: Version.parse,
          help: 'version',
        );

  @override
  Version parse(List<String> args) {
    final version = super.parse(args);
    if (version == null) {
      throw FormatException('Option $name is mandatory.');
    }
    return version;
  }
}
