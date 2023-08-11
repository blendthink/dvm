enum ExitCode {
  success(0),
  warnings(1),
  errors(2),
  usage(64),
  ;

  const ExitCode(this.code);

  final int code;
}
