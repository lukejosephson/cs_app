import 'package:cs_app/utils/answer_normalizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('normalize trims, collapses whitespace, and lowercases text', () {
    expect(AnswerNormalizer.normalize('  Hello   WORLD  '), 'hello world');
  });
}
