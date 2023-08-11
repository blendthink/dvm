sealed class Option {
  const Option();
}

sealed class SingleOption<V> extends Option {
  const SingleOption(this.value);

  final OptionValue<V> value;
}

sealed class MultiOption<V> extends Option {
  const MultiOption(this.values);

  final OptionValue<V> values;
}

abstract class FlagOption extends SingleOption<bool> {
  // ignore: avoid_positional_boolean_parameters
  const FlagOption(super.value);
}

abstract class ValueOption<V> implements SingleOption<V> {}

abstract class ValuesOption<V> implements MultiOption<V> {}

abstract class OptionValue<V> {
  const OptionValue(this.value);

  final V value;
}
