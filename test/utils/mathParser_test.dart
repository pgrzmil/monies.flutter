import 'package:flutter_test/flutter_test.dart';
import 'package:monies/utils/mathParser.dart';

main() {
  test('incorrect format test', () {
    final MathExpressionParser parser = MathExpressionParser();

    String operationString = "2+2";
    expect(() => parser.parse(operationString).perform(), throwsA(isInstanceOf<FormatException>()));

    operationString = "=2 #not closed comment +2";
    expect(() => parser.parse(operationString).perform(), throwsA(isInstanceOf<FormatException>()));

    operationString = "=2sometrashinput&^% +2";
    expect(parser.parse(operationString).perform(), equals(4));

    operationString = "=2*2/+";
    expect(() => parser.parse(operationString).perform(), throwsA(isInstanceOf<FormatException>()));
  });

  test('addition test', () {
    final MathExpressionParser parser = MathExpressionParser();

    String operationString = "=2+2";
    expect(parser.parse(operationString).perform(), equals(4));

    operationString = "=2+2+5";
    expect(parser.parse(operationString).perform(), equals(9));

    operationString = "=  2.6 +  2.4+5.1   ";
    expect(parser.parse(operationString).perform(), equals(10.1));

    operationString = "=-2.5+2.5+5.2";
    expect(parser.parse(operationString).perform(), equals(5.2));
  });

  test('subtraction test', () {
    final MathExpressionParser parser = MathExpressionParser();

    String operationString = "=2-2";
    expect(parser.parse(operationString).perform(), equals(0));

    operationString = "=-2-2.3";
    expect(parser.parse(operationString).perform(), equals(-4.3));

    operationString = "=-2+7-2.3";
    expect(parser.parse(operationString).perform(), equals(2.7));

    operationString = "=-2+7-2.3+5+15-5";
    expect(parser.parse(operationString).perform(), equals(17.7));

    operationString = "=-2+7- -2.3";
    expect(parser.parse(operationString).perform(), moreOrLessEquals(7.3, epsilon: 0.0000001));
  });

  test('multiplication test', () {
    final MathExpressionParser parser = MathExpressionParser();

    String operationString = "=2*4";
    expect(parser.parse(operationString).perform(), equals(8));

    operationString = "=2+2*2";
    expect(parser.parse(operationString).perform(), equals(6));

    operationString = "=2*2+2";
    expect(parser.parse(operationString).perform(), equals(6));

    operationString = "=2-4*2+7";
    expect(parser.parse(operationString).perform(), equals(1));
  });

  test('division by zero test', () {
    final MathExpressionParser parser = MathExpressionParser();

    String operationString = "=2/0";
    expect(() => parser.parse(operationString).perform(), throwsA(isInstanceOf<IntegerDivisionByZeroException>()));
  });

  test('division test', () {
    final MathExpressionParser parser = MathExpressionParser();

    String operationString = "=2/4";
    expect(parser.parse(operationString).perform(), equals(0.5));

    operationString = "=7+5/1*2";
    expect(parser.parse(operationString).perform(), equals(17));
  });

  test('parenthesis test', () {
    final MathExpressionParser parser = MathExpressionParser();

    String operationString = "=(2+2)*2";
    expect(parser.parse(operationString).perform(), equals(8));

    operationString = "=(7+5)/(1*2)";
    expect(parser.parse(operationString).perform(), equals(6));

    operationString = "=2 *((7+0.5)/3)-1";
    expect(parser.parse(operationString).perform(), equals(4));

    operationString = "=(2+2*2";
    expect(() => parser.parse(operationString).perform(), throwsA(isInstanceOf<FormatException>()));
  });

  test('comments test', () {
    final MathExpressionParser parser = MathExpressionParser();

    String operationString = "=(2+2)#comment#*2";
    expect(parser.parse(operationString).perform(), equals(8));

    operationString = "=(7+5)#value 1#/(1*2)#comment 2#";
    expect(parser.parse(operationString).perform(), equals(6));
  });
}
