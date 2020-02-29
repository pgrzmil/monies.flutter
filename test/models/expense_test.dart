import 'package:flutter_test/flutter_test.dart';
import 'package:monies/data/models/expense.dart';
import 'package:monies/utils/formatters.dart';

void main() {
  group('JSON parsing', () {
    test('Expense.toJson returns Map with String key', () {
      final expense = Expense("1", "test_title", "test_location", 123.45, DateTime(2020, 1, 23), "cat_id", recurringExpenseId: "rec_expense_id");

      final json = expense.toJsonMap();

      expect(json, isNotNull);
      expect(json, isA<Map<String, dynamic>>());
      expect(json, hasLength(7));
      expect(json.containsKey("id"), isTrue);
      expect(json.containsKey("title"), isTrue);
      expect(json.containsKey("location"), isTrue);
      expect(json.containsKey("amount"), isTrue);
      expect(json.containsKey("date"), isTrue);
      expect(json.containsKey("categoryId"), isTrue);
      expect(json.containsKey("recurringExpenseId"), isTrue);
      expect(json["id"], equals("1"));
      expect(json["title"], equals("test_title"));
      expect(json["location"], equals("test_location"));
      expect(json["amount"], equals(123.45));
      expect(json["date"], equals("2020-01-23T00:00:00.000"));
      expect(json["categoryId"], equals("cat_id"));
      expect(json["recurringExpenseId"], equals("rec_expense_id"));
    });

    test('Expense.fromJson returns Expense object', () {
      final json = {"id": "1", "title": "test_title", "location": "test_location", "amount": 123.45, "date": "2020-01-23T00:00:00.000", "categoryId": "cat_id", "recurringExpenseId": "rec_expense_id"};

      final expense = Expense.fromJsonMap(json);

      expect(expense, isNotNull);
      expect(expense, isA<Expense>());
      expect(expense.id, equals("1"));
      expect(expense.title, equals("test_title"));
      expect(expense.location, equals("test_location"));
      expect(expense.amount, equals(123.45));
      expect(expense.date, DateTime(2020, 1, 23));
      expect(expense.categoryId, equals("cat_id"));
      expect(expense.recurringExpenseId, equals("rec_expense_id"));
    });

    test('Expense.toJsonString returns valid json string', () {
      final expense = Expense("1", "test_title", "test_location", 123.45, DateTime(2020, 1, 23), "cat_id");

      final jsonString = expense.toJsonString();

      expect(jsonString, isNotNull);
      expect(jsonString, isA<String>());
      expect(jsonString, equals(r'{"id":"1","title":"test_title","location":"test_location","amount":123.45,"date":"2020-01-23T00:00:00.000","categoryId":"cat_id","recurringExpenseId":null}'));
    });

    test('Expense.fromJsonString returns Expense object', () {
      final jsonString = r'{"id":"1","title":"test_title","location":"test_location","amount":123.45,"date":"2020-01-23T00:00:00.000","categoryId":"cat_id","recurringExpenseId":"rec_expense_id"}';

      final expense = Expense.fromJsonString(jsonString);

      expect(expense, isNotNull);
      expect(expense, isA<Expense>());
      expect(expense.id, equals("1"));
      expect(expense.title, equals("test_title"));
      expect(expense.location, equals("test_location"));
      expect(expense.amount, equals(123.45));
      expect(expense.date, DateTime(2020, 1, 23));
      expect(expense.categoryId, equals("cat_id"));
      expect(expense.recurringExpenseId, equals("rec_expense_id"));
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

  test('.empty() returns correctly initialized object', () {
    final expense = Expense.empty();

    expect(expense, isNotNull);
    expect(expense.id, isNot(equals("")));
    expect(expense.title, equals(""));
    expect(expense.location, equals(""));
    expect(expense.amount, equals(0));
    expect(expense.date, isNotNull);
    expect(expense.dateString, equals(Format.date(DateTime.now())));
    expect(expense.categoryId, isNull);
    expect(expense.recurringExpenseId, isNull);
  });

  test('Returns amount string', () {
    final expense = Expense("1", "test_title", "test_location", 123.45, DateTime(2020, 1, 23), "cat_id");

    expect(expense, isNotNull);
    expect(expense.amountString, "123,45 zł");
  });

   test('Returns date string', () {
    final expense = Expense("1", "test_title", "test_location", 123.45, DateTime(2020, 1, 23), "cat_id");

    expect(expense, isNotNull);
    expect(expense.dateString, "23/01/2020");
  });

   test('Returns title for displaying', () {
    final expense = Expense("1", "test_title", "test_location", 123.45, DateTime(2020, 1, 23), "cat_id");

    expect(expense, isNotNull);
    expect(expense.displayTitle, "test_title - test_location");
  });
}
