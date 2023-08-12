enum ExitStatus {
  success(0),
  warnings(1),
  errors(2),
  usage(64),
  ;

  const ExitStatus(this.code);

  final int code;
}
