/// See https://dart.dev/get-dart
///
/// Stable channel releases of the Dart SDK have x.y.z version strings like
/// 1.24.3 and 2.1.0. They consist of dot-separated integers, with no hyphens or
/// letters, where x is the major version, y is the minor version, and z is
/// the patch version.
///
/// Beta and dev channel releases of the Dart SDK (non-stable releases) have
/// x.y.z-a.b.<beta|dev> versions like 2.8.0-20.11.beta. The part before
/// the hyphen follows the stable version scheme, a and b after the hyphen are
/// the prerelease and prerelease patch versions, and beta or dev is
/// the channel.
class DartSdkVersion {
  const DartSdkVersion.stable({
    required this.major,
    required this.minor,
    required this.patch,
  })  : channel = DartSdkChannel.stable,
        preMinor = null,
        prePatch = null;

  const DartSdkVersion.beta({
    required this.major,
    required this.minor,
    required this.patch,
    required int this.preMinor,
    required int this.prePatch,
  }) : channel = DartSdkChannel.beta;

  const DartSdkVersion.dev({
    required this.major,
    required this.minor,
    required this.patch,
    required int this.preMinor,
    required int this.prePatch,
  }) : channel = DartSdkChannel.dev;

  factory DartSdkVersion.fromString(String value) {
    const nameMajor = 'major';
    const nameMinor = 'minor';
    const namePatch = 'patch';
    const namePreMinor = 'pre_minor';
    const namePrePatch = 'pre_patch';
    const nameChannel = 'channel';

    final regex = RegExp(
      '''^(?<$nameMajor>\\d+).(?<$nameMinor>\\d+).(?<$namePatch>\\d+)(-(?<$namePreMinor>\\d+).(?<$namePrePatch>\\d+).(?<$nameChannel>beta|dev))?\$''',
    );
    final match = regex.firstMatch(value);
    if (match == null) {
      throw FormatException('Invalid Dart SDK version: $value');
    }

    final major = int.parse(match.namedGroup(nameMajor)!);
    final minor = int.parse(match.namedGroup(nameMinor)!);
    final patch = int.parse(match.namedGroup(namePatch)!);

    final channelName = match.namedGroup(nameChannel) ?? 'stable';
    final channel = DartSdkChannel.values.byName(channelName);
    if (channel == DartSdkChannel.stable) {
      return DartSdkVersion.stable(
        major: major,
        minor: minor,
        patch: patch,
      );
    }

    final preMinor = int.parse(match.namedGroup(namePreMinor)!);
    final prePatch = int.parse(match.namedGroup(namePrePatch)!);
    if (channel == DartSdkChannel.beta) {
      return DartSdkVersion.beta(
        major: major,
        minor: minor,
        patch: patch,
        preMinor: preMinor,
        prePatch: prePatch,
      );
    } else {
      return DartSdkVersion.dev(
        major: major,
        minor: minor,
        patch: patch,
        preMinor: preMinor,
        prePatch: prePatch,
      );
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer()..write('$major.$minor.$patch');
    if (channel != DartSdkChannel.stable &&
        preMinor != null &&
        prePatch != null) {
      buffer.write('-$preMinor.$prePatch.${channel.name}');
    }
    return buffer.toString();
  }

  final int major;
  final int minor;
  final int patch;
  final DartSdkChannel channel;
  final int? preMinor;
  final int? prePatch;
}

enum DartSdkChannel {
  stable,
  beta,
  dev,
}
