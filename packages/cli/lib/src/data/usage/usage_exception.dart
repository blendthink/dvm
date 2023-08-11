import 'package:cli/src/data/usage/usage.dart';

class UsageException implements Exception {
  const UsageException(this.message, this.usage);

  final String message;
  final Usage usage;
}
