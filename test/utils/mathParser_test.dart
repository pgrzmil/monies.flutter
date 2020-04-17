import 'package:flutter_test/flutter_test.dart';
import 'package:monies/utils/mathParser.dart';

main() {
  test('incorrect format test', () {
    String operationString = "2+2";
    expect(() => MathExpressionParser.parseOperation(operationString), throwsA(isInstanceOf<FormatException>()));

    operationString = "=2 #not closed comment +2";
    expect(() => MathExpressionParser.parseValue(operationString), throwsA(isInstanceOf<FormatException>()));

    operationString = "=2sometrashinput&^% +2";
    expect(MathExpressionParser.parseValue(operationString), equals(4));

    operationString = "=2*2/+";
    expect(() => MathExpressionParser.parseValue(operationString), throwsA(isInstanceOf<FormatException>()));

    operationString = "11 14";
    expect(MathExpressionParser.parseValue(operationString), equals(1114));

    operationString = "";
    expect(MathExpressionParser.parseValue(operationString), isNull);

    operationString = null;
    expect(MathExpressionParser.parseValue(operationString), isNull);
  });

  test('addition test', () {
    String operationString = "=2+2";
    expect(MathExpressionParser.parseValue(operationString), equals(4));

    operationString = "=2+2+5";
    expect(MathExpressionParser.parseValue(operationString), equals(9));

    operationString = "=  2.6 +  2.4+5.1   ";
    expect(MathExpressionParser.parseValue(operationString), equals(10.1));

    operationString = "=-2.5+2.5+5.2";
    expect(MathExpressionParser.parseValue(operationString), equals(5.2));
  });

  test('subtraction test', () {
    String operationString = "=2-2";
    expect(MathExpressionParser.parseValue(operationString), equals(0));

    operationString = "=-2-2.3";
    expect(MathExpressionParser.parseValue(operationString), equals(-4.3));

    operationString = "=-2+7-2.3";
    expect(MathExpressionParser.parseValue(operationString), equals(2.7));

    operationString = "=-2+7-2.3+5+15-5";
    expect(MathExpressionParser.parseValue(operationString), equals(17.7));

    operationString = "=-2+7- -2.3";
    expect(MathExpressionParser.parseValue(operationString), moreOrLessEquals(7.3, epsilon: 0.0000001));
  });

  test('multiplication test', () {
    String operationString = "=2*4";
    expect(MathExpressionParser.parseValue(operationString), equals(8));

    operationString = "=2+2*2";
    expect(MathExpressionParser.parseValue(operationString), equals(6));

    operationString = "=2*2+2";
    expect(MathExpressionParser.parseValue(operationString), equals(6));

    operationString = "=2-4*2+7";
    expect(MathExpressionParser.parseValue(operationString), equals(1));
  });

  test('division by zero test', () {
    String operationString = "=2/0";
    expect(() => MathExpressionParser.parseValue(operationString), throwsA(isInstanceOf<IntegerDivisionByZeroException>()));
  });

  test('division test', () {
    String operationString = "=2/4";
    expect(MathExpressionParser.parseValue(operationString), equals(0.5));

    operationString = "=7+5/1*2";
    expect(MathExpressionParser.parseValue(operationString), equals(17));
  });

  test('parenthesis test', () {
    String operationString = "=(2+2)*2";
    expect(MathExpressionParser.parseValue(operationString), equals(8));

    operationString = "=(7+5)/(1*2)";
    expect(MathExpressionParser.parseValue(operationString), equals(6));

    operationString = "=2 *((7+0.5)/3)-1";
    expect(MathExpressionParser.parseValue(operationString), equals(4));

    operationString = "=(2+2*2";
    expect(() => MathExpressionParser.parseValue(operationString), throwsA(isInstanceOf<FormatException>()));
  });

  test('comments test', () {
    String operationString = "=(2+2)#comment#*2";
    expect(MathExpressionParser.parseValue(operationString), equals(8));

    operationString = "=(7+5)#value 1#/(1*2)#comment 2#";
    expect(MathExpressionParser.parseValue(operationString), equals(6));
  });

  test('value test', () {
    String operationString = "15";
    expect(MathExpressionParser.parseValue(operationString), equals(15));

    operationString = "15.67";
    expect(MathExpressionParser.parseValue(operationString), equals(15.67));

    operationString = "15,67";
    expect(MathExpressionParser.parseValue(operationString), equals(15.67));
  });
}
