import 'package:flutter_test/flutter_test.dart';
import 'package:monies/data/models/income.dart';
import 'package:monies/utils/formatters.dart';

void main() {
  group('JSON parsing', () {
    test('toJsonString returns valid json string', () {
      final income = Income("1", "test_title", 123.45, DateTime(2020, 1, 23), "user123");

      final jsonString = income.toJsonString();

      expect(jsonString, isNotNull);
      expect(jsonString, isA<String>());
      expect(jsonString, equals(r'{"id":"1","userId":"user123","title":"test_title","amount":123.45,"date":"2020-01-23T00:00:00.000"}'));
    });

    test('fromJsonString returns valid object', () {
      final jsonString = r'{"id":"1","title":"test_title","amount":123.45,"date":"2020-01-23T00:00:00.000"}';

      final income = Income.fromJsonString(jsonString);

      expect(income, isNotNull);
      expect(income, isA<Income>());
      expect(income.id, equals("1"));
      expect(income.title, equals("test_title"));
      expect(income.amount, equals(123.45));
      expect(income.date, equals(DateTime(2020, 1, 23)));
    });

    test('fromJsonString throws FormatException when called with malformed string', () {
      final jsonString = r'{malformed_json_string}';

      try {
        Income.fromJsonString(jsonString);
      } on FormatException {
        expect(true, isTrue);
        return;
      }

      fail("FormatException should be raised");
    });
  });

  test('.empty() returns correctly initialized object', () {
    final income = Income.empty("user123");

    expect(income, isNotNull);
    expect(income.id, isNot(equals("")));
    expect(income.title, equals(""));
    expect(income.amount, equals(0));
    expect(income.userId, equals("user123"));
    expect(income.date, isNotNull);
    expect(income.dateString, equals(Format.date(DateTime.now())));
  });

  test('Returns amount string', () {
    final income = Income("1", "test_title", 123.45, DateTime(2020, 1, 23), "user123");

    expect(income, isNotNull);
    expect(income.amountString, equals("123,45 zł"));
  });

   test('Returns date string', () {
    final income = Income("1", "test_title", 123.45, DateTime(2020, 1, 23), "user123");

    expect(income, isNotNull);
    expect(income.dateString, equals("23/01/2020"));
  }); 
}