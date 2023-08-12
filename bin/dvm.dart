import 'package:dvm/dvm.dart';

Future<void> main(List<String> args) async {
  final cli = DvmCli();
  return cli.run(args);
}
