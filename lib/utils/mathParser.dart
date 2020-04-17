typedef OperationFunction = double Function();
typedef ParseFunction = MathOperation Function(String str);
typedef InitFunc = MathOperation Function(MathOperation op1, MathOperation op2);

abstract class MathOperation {
  double perform();
}

class Value implements MathOperation {
  final double value;

  Value(this.value);

  @override
  double perform() => value;
}

abstract class TwoOperandsMathOperation {
  MathOperation op1;
  MathOperation op2;

  get operationSign => "";

  TwoOperandsMathOperation.fromString(String str, ParseFunction parseCallback, {int startIndex = 0}) {
    final signIndex = str.indexOf(operationSign, startIndex);
    final left = str.substring(0, signIndex);
    final right = str.substring(signIndex + 1);
    op1 = parseCallback(left);
    op2 = parseCallback(right);
  }
}

class AddOperation extends TwoOperandsMathOperation implements MathOperation {
  AddOperation.fromString(String str, ParseFunction parseCallback) : super.fromString(str, parseCallback);

  @override
  get operationSign => "+";

  @override
  double perform() {
    return op1.perform() + op2.perform();
  }
}

class SubtractionOperation extends TwoOperandsMathOperation implements MathOperation {
  SubtractionOperation.fromString(String str, ParseFunction parseCallback) : super.fromString(str, parseCallback, startIndex: 1);

  @override
  get operationSign => "-";

  @override
  double perform() {
    return op1.perform() - op2.perform();
  }
}

class MultiplicationOperation extends TwoOperandsMathOperation implements MathOperation {
  MultiplicationOperation.fromString(String str, ParseFunction parseCallback) : super.fromString(str, parseCallback);

  @override
  get operationSign => "*";

  @override
  double perform() {
    return op1.perform() * op2.perform();
  }
}

class DivisionOperation extends TwoOperandsMathOperation implements MathOperation {
  DivisionOperation.fromString(String str, ParseFunction parseCallback) : super.fromString(str, parseCallback);

  @override
  get operationSign => "/";

  @override
  double perform() {
    final op2Value = op2.perform();

    if (op2Value == 0) {
      throw IntegerDivisionByZeroException();
    }

    return op1.perform() / op2Value;
  }
}

class MathExpressionParser {
  MathExpressionParser._();

  static double parseValue(String expressionString) {
    expressionString = sanitizeInput(expressionString);

    if (expressionString == null || expressionString.isEmpty) {
      return null;
    }

    double value = double.tryParse(expressionString);
    if (value == null) {
      value = MathExpressionParser.parseOperation(expressionString).perform();
    }

    return value;
  }

  static MathOperation parseOperation(String expressionString) {
    expressionString = sanitizeInput(expressionString);

    if (expressionString.isEmpty || !expressionString.startsWith("=") || expressionString.contains(RegExp(r"[^0-9.+\-*/()=]"))) {
      throw FormatException("Incorrect expression format");
    }
    return _parse(expressionString.substring(1));
  }

  static MathOperation _parse(String expressionString) {
    double value = double.tryParse(expressionString);

    if (value != null) {
      return Value(value);
    } else if (expressionString.contains("(")) {
      final openingIndex = expressionString.lastIndexOf("(");
      final closingIndex = expressionString.indexOf(")", openingIndex);
      if (closingIndex == -1) {
        throw FormatException("Missing parenthesis");
      }

      final insideExpression = expressionString.substring(openingIndex + 1, closingIndex);
      final insiderResult = _parse(insideExpression).perform();

      expressionString = expressionString.replaceAll("($insideExpression)", insiderResult.toString());

      return _parse(expressionString);
    } else if (expressionString.contains("+")) {
      return AddOperation.fromString(expressionString, _parse);
    } else if (expressionString.contains("-")) {
      return SubtractionOperation.fromString(expressionString, _parse);
    } else if (expressionString.contains("*")) {
      return MultiplicationOperation.fromString(expressionString, _parse);
    } else if (expressionString.contains("/")) {
      return DivisionOperation.fromString(expressionString, _parse);
    }

    throw FormatException("Unsupported operation");
  }

  static String sanitizeInput(String expressionString) {
    if (expressionString != null && expressionString.isNotEmpty) {
      expressionString = removeWhitespaces(expressionString);
      expressionString = removeComments(expressionString);
      expressionString = expressionString.replaceAll(",", ".");
      expressionString = expressionString.replaceAll(RegExp(r"[^0-9.+\-*/()=]"), "");
    }
    return expressionString;
  }

  static String removeWhitespaces(String str) {
    return str.replaceAll(RegExp(r"\s+\b|\b\s"), "");
  }

  static String removeComments(String str) {
    final commentSign = "#";

    while (str.contains(commentSign)) {
      final openingIndex = str.indexOf(commentSign);
      final closingIndex = str.indexOf(commentSign, openingIndex + 1);

      if (openingIndex == -1 && closingIndex == -1) {
        return str;
      }
      if (openingIndex == -1 || closingIndex == -1) {
        throw FormatException("One of the comments is not opened or closed properly");
      }

      str = str.replaceRange(openingIndex, closingIndex + 1, "");
    }

    return str;
  }
}
