import 'dart:ffi';

const _nameOs = 'os';
const _nameArch = 'architecture';
final _abiRegex = RegExp('^(?<$_nameOs>[a-z]+)_(?<$_nameArch>[\\da-z]+)\$');

extension AbiExt on Abi {
  ({String os, String architecure}) get osAndArch {
    final match = _abiRegex.firstMatch(toString());
    if (match == null) {
      throw Exception('Could not parse ABI: $this');
    }
    final os = match.namedGroup(_nameOs)!;
    final arch = match.namedGroup(_nameArch)!;
    return (os: os, architecure: arch);
  }
}
