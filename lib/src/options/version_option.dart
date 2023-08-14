import 'package:cli/cli.dart';
import 'package:pub_semver/pub_semver.dart';

final class VersionOption extends ValueOption<Version> {
  const VersionOption()
      : super(
          name: 'version',
          defaultsTo: null,
          mandatory: false,
          parseValue: Version.parse,
          help: 'version',
        );
}
