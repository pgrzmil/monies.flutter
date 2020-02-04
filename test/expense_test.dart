import 'package:flutter_test/flutter_test.dart';
import 'package:monies/data/models/expense.dart';

void main() {
  group('JSON parsing', () {
    test('Expense.toJson returns Map with String key', () {
      final expense = Expense("1", "test_title", "test_location", 123.45, DateTime(2020, 1, 23));

      final json = expense.toJson();

      expect(json, isNotNull);
      expect(json, isA<Map<String, dynamic>>());
      expect(json, hasLength(4));
      expect(json.containsKey("id"), isTrue);
      expect(json.containsKey("title"), isTrue);
      expect(json.containsKey("location"), isTrue);
      expect(json.containsKey("amount"), isTrue);
      expect(json["id"], equals("1"));
      expect(json["title"], equals("test_title"));
      expect(json["location"], equals("test_location"));
      expect(json["amount"], equals(123.45));
    });

    test('Expense.fromJson returns Expense object', () {
      final json = {"id": "1", "title": "test_title", "location": "test_location", "amount": 123.45};

      final expense = Expense.fromJson(json);

      expect(expense, isNotNull);
      expect(expense, isA<Expense>());
      expect(expense.id, equals("1"));
      expect(expense.title, equals("test_title"));
      expect(expense.location, equals("test_location"));
      expect(expense.amount, equals(123.45));
    });

    test('Expense.toJsonString returns valid json string', () {
      final expense = Expense("1", "test_title", "test_location", 123.45, DateTime(2020, 1, 23));

      final jsonString = expense.toJsonString();

      expect(jsonString, isNotNull);
      expect(jsonString, isA<String>());
      expect(jsonString, equals(r'{"id":"1","title":"test_title","location":"test_location","amount":123.45}'));
    });

    test('Expense.fromJsonString returns Expense object', () {
      final jsonString = r'{"id":"1","title":"test_title","location":"test_location","amount":123.45}';

      final expense = Expense.fromJsonString(jsonString);

      expect(expense, isNotNull);
      expect(expense, isA<Expense>());
      expect(expense.id, equals("1"));
      expect(expense.title, equals("test_title"));
      expect(expense.location, equals("test_location"));
      expect(expense.amount, equals(123.45));
    });

    test('Expense.fromJsonString throws FormatException when called with malformed string', () {
      final jsonString = r'{malformed_json_string}';

      try {
        Expense.fromJsonString(jsonString);
      } on FormatException {
        expect(true, isTrue);
        return;
      }

      fail("FormatException should be raised");
    });
  });

  test('Returns amount string', () {
      final expense = Expense("1", "test_title", "test_location", 123.45, DateTime(2020, 1, 23));

      expect(expense, isNotNull);
      expect(expense.amountString, "123.45 zł");
  });
}
