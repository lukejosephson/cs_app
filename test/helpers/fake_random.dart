import 'dart:math';

class FakeRandom implements Random {
  FakeRandom(this._values);

  final List<int> _values;
  var _index = 0;

  @override
  int nextInt(int max) {
    final value = _values[_index % _values.length];
    _index++;
    return value % max;
  }

  @override
  bool nextBool() => nextInt(2) == 1;

  @override
  double nextDouble() => nextInt(1000000) / 1000000;
}
