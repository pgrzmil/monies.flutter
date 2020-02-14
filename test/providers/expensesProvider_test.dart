import 'package:flutter_test/flutter_test.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/data/models/expense.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monies/utils/testDataHelpers.dart';

void main() {
  SharedPreferences preferences;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
  });

  tearDown(() async {
    await preferences.clear();
  });

  group('Adding expense', () {
    test('Adds new expense', () async {
      var callbackFired = false;
      final expense = Expense.fromValues("test title", "test location", 123.45, DateTime(2020, 1, 23), "cat_id");
      final expensesProvider = ExpensesProvider();
      expensesProvider.addListener(() => callbackFired = true);

      expect((await expensesProvider.getAll()).length, equals(0));
      expect(preferences.getStringList("Expenses"), isNull);

      await expensesProvider.add(expense);

      final allExpenses = await expensesProvider.getAll();
      expect(allExpenses.length, equals(1));

      final expenseFromList = allExpenses.first;
      expect(expenseFromList, equals(expense));
      expect(expenseFromList.title, equals("test title"));
      expect(expenseFromList.location, equals("test location"));
      expect(expenseFromList.amount, equals(123.45));
      expect(expenseFromList.date, DateTime(2020, 1, 23));
      expect(expenseFromList.categoryId, equals("cat_id"));

      expect(preferences.getStringList("Expenses").length, equals(1));

      expect(callbackFired, isTrue);
    });

    test('Prevents adding existing expense', () async {
      final expense = Expense.fromValues("test title", "test location", 123.45, DateTime(2020, 1, 23), "cat_id");
      final expensesProvider = ExpensesProvider();
      await expensesProvider.add(expense);
      expensesProvider.addListener(() => fail("Expense should not be added and change notification should not be called"));

      expect((await expensesProvider.getAll()).length, equals(1));
      expect(preferences.getStringList("Expenses").length, equals(1));

      await expensesProvider.add(expense);

      final allExpenses = await expensesProvider.getAll();
      expect(allExpenses.length, equals(1));

      final expenseFromList = allExpenses.first;
      expect(expenseFromList, equals(expense));
      expect(expenseFromList.title, equals("test title"));
      expect(expenseFromList.location, equals("test location"));
      expect(expenseFromList.amount, equals(123.45));
      expect(expenseFromList.date, DateTime(2020, 1, 23));
      expect(expenseFromList.categoryId, equals("cat_id"));

      expect(preferences.getStringList("Expenses").length, equals(1));
    });

    test('Prevents adding null', () async {
      final expensesProvider = ExpensesProvider();
      expensesProvider.addListener(() => fail("Expense should not be added and change notification should not be called"));

      expect((await expensesProvider.getAll()).length, equals(0));
      expect(preferences.getStringList("Expenses"), isNull);

      await expensesProvider.add(null);

      expect((await expensesProvider.getAll()).length, equals(0));
      expect(preferences.getStringList("Expenses"), isNull);
    });
  });

  group('Editing expense', () {
    test('Edits existing expense', () async {
      var callbackFired = false;
      final expensesProvider = ExpensesProvider();
      var expense = await TestDataHelpers.addRandomExpense(expensesProvider);
      expensesProvider.addListener(() => callbackFired = true);

      expect((await expensesProvider.getAll()).length, equals(1));
      expect(preferences.getStringList("Expenses").length, equals(1));

      expense.title = "test title";
      expense.location = "test location";
      expense.amount = 123.45;
      expense.date = DateTime(2020, 1, 23);
      expense.categoryId = "cat_id";

      await expensesProvider.edit(expense);

      final allExpenses = await expensesProvider.getAll();
      expect(allExpenses.length, equals(1));

      final expenseFromList = allExpenses.first;
      expect(expenseFromList, equals(expense));
      expect(expenseFromList.title, equals("test title"));
      expect(expenseFromList.location, equals("test location"));
      expect(expenseFromList.amount, equals(123.45));
      expect(expenseFromList.date, equals(DateTime(2020, 1, 23)));
      expect(expenseFromList.categoryId, equals("cat_id"));

      expect(preferences.getStringList("Expenses").length, equals(1));

      expect(callbackFired, isTrue);
    });

    test('Prevents editing not added expense', () async {
      final expensesProvider = ExpensesProvider();
      await TestDataHelpers.addRandomExpense(expensesProvider);
      expensesProvider.addListener(() => fail("Expense should not be edited and change notification should not be called"));

      var expense = Expense.empty();

      expect((await expensesProvider.getAll()).length, equals(1));
      expect(preferences.getStringList("Expenses").length, equals(1));

      expense.title = "test title";
      expense.location = "test location";
      expense.amount = 123.45;
      expense.date = DateTime(2020, 1, 23);
      expense.categoryId = "cat_id";

      await expensesProvider.edit(expense);

      final allExpenses = await expensesProvider.getAll();
      expect(allExpenses.length, equals(1));

      final expenseFromList = allExpenses.first;
      expect(expenseFromList, isNot(equals(expense)));
      expect(expenseFromList.title, isNot(equals("test title")));
      expect(expenseFromList.location, isNot(equals("test location")));
      expect(expenseFromList.amount, isNot(equals(123.45)));
      expect(expenseFromList.date, isNot(equals(DateTime(2020, 1, 23))));
      expect(expenseFromList.categoryId, isNot(equals("cat_id")));

      expect(preferences.getStringList("Expenses").length, equals(1));
    });

    test('Prevents editing null', () async {
      final expensesProvider = ExpensesProvider();
      await TestDataHelpers.addRandomExpense(expensesProvider);
      expensesProvider.addListener(() => fail("Expense should not be edited and change notification should not be called"));

      expect((await expensesProvider.getAll()).length, equals(1));
      expect(preferences.getStringList("Expenses").length, equals(1));

      await expensesProvider.remove(null);

      expect((await expensesProvider.getAll()).length, equals(1));
      expect(preferences.getStringList("Expenses").length, equals(1));
    });
  });

  group('Removing expense', () {
    test('Removes existing expense', () async {
      var callbackFired = false;
      final expensesProvider = ExpensesProvider();
      var expense = await TestDataHelpers.addRandomExpense(expensesProvider);
      expensesProvider.addListener(() => callbackFired = true);

      expect((await expensesProvider.getAll()).length, equals(1));
      expect(preferences.getStringList("Expenses").length, equals(1));

      await expensesProvider.remove(expense);

      final allExpenses = await expensesProvider.getAll();
      expect(allExpenses.length, equals(0));
      expect(preferences.getStringList("Expenses").length, equals(0));
      expect(callbackFired, isTrue);
    });

    test('Prevents removing not added expense', () async {
      final expensesProvider = ExpensesProvider();
      await TestDataHelpers.addRandomExpense(expensesProvider);
      expensesProvider.addListener(() => fail("Expense should not be removed and change notification should not be called"));

      var expense = Expense.fromValues("test title", "test location", 123.45, DateTime(2020, 1, 23), "cat_id");

      expect((await expensesProvider.getAll()).length, equals(1));
      expect(preferences.getStringList("Expenses").length, equals(1));

      await expensesProvider.remove(expense);

      final allExpenses = await expensesProvider.getAll();
      expect(allExpenses.length, equals(1));

      final expenseFromList = allExpenses.first;
      expect(expenseFromList, isNot(equals(expense)));
      expect(preferences.getStringList("Expenses").length, equals(1));
    });

    test('Prevents removing null', () async {
      final expensesProvider = ExpensesProvider();
      await TestDataHelpers.addRandomExpense(expensesProvider);
      expensesProvider.addListener(() => fail("Expense should not be removed and change notification should not be called"));

      expect((await expensesProvider.getAll()).length, equals(1));
      expect(preferences.getStringList("Expenses").length, equals(1));

      await expensesProvider.remove(null);

      expect((await expensesProvider.getAll()).length, equals(1));
      expect(preferences.getStringList("Expenses").length, equals(1));
    });
  });

  group('Getting expenses', () {
    test('Gets all expenses', () async {
      final expensesProvider = ExpensesProvider();
      final expense = Expense.fromValues("test title", "test location", 123.45, DateTime(2020, 1, 23), "cat_id");
      await expensesProvider.add(expense);
      await TestDataHelpers.addRandomExpense(expensesProvider);
      expensesProvider.addListener(() => fail("Change notification should not be called on retrieving items"));

      final allExpenses = await expensesProvider.getAll();
      expect(allExpenses.length, equals(2));

      final expenseFromList = allExpenses.first;
      expect(expenseFromList, equals(expense));
      expect(expenseFromList.title, equals("test title"));
      expect(expenseFromList.location, equals("test location"));
      expect(expenseFromList.amount, equals(123.45));
      expect(expenseFromList.date, DateTime(2020, 1, 23));
      expect(expenseFromList.categoryId, equals("cat_id"));

      expect(preferences.getStringList("Expenses").length, equals(2));
    });

    test('Gets empty list when there is no expenses added', () {
      final expensesProvider = ExpensesProvider();
      expensesProvider.addListener(() => fail("Change notification should not be called on retrieving items"));

      final allExpenses = expensesProvider.getAll();
      expect(allExpenses.length, equals(0));
      expect(preferences.getStringList("Expenses"), isNull);
    });

    test('Gets expenses by id', () async {
      final expensesProvider = ExpensesProvider();
      final expense = Expense("id123", "test title", "test location", 123.45, DateTime(2020, 1, 23), "cat_id");
      await expensesProvider.add(expense);
      await TestDataHelpers.addRandomExpense(expensesProvider);
      expensesProvider.addListener(() => fail("Change notification should not be called on retrieving items"));

      final retrievedExpense = expensesProvider.getBy(id: "id123");
      expect(retrievedExpense, isNotNull);
      expect(retrievedExpense, equals(expense));
      expect(retrievedExpense.title, equals("test title"));
      expect(retrievedExpense.location, equals("test location"));
      expect(retrievedExpense.amount, equals(123.45));
      expect(retrievedExpense.date, DateTime(2020, 1, 23));
      expect(retrievedExpense.categoryId, equals("cat_id"));

      expect(preferences.getStringList("Expenses").length, equals(2));
    });

    test('Returns null when there is no expense with passed id', () async {
      final expensesProvider = ExpensesProvider();
      final expense = Expense("id123", "test title", "test location", 123.45, DateTime(2020, 1, 23), "cat_id");
      await expensesProvider.add(expense);
      await TestDataHelpers.addRandomExpense(expensesProvider);
      expensesProvider.addListener(() => fail("Change notification should not be called on retrieving items"));

      final retrievedExpense = expensesProvider.getBy(id: "notexistingid");
      expect(retrievedExpense, isNull);
      expect(preferences.getStringList("Expenses").length, equals(2));
    });

    test('Returns null when passing null id', () async {
      final expensesProvider = ExpensesProvider();
      final expense = Expense("id123", "test title", "test location", 123.45, DateTime(2020, 1, 23), "cat_id");
      await expensesProvider.add(expense);
      await TestDataHelpers.addRandomExpense(expensesProvider);
      expensesProvider.addListener(() => fail("Change notification should not be called on retrieving items"));

      final retrievedExpense = expensesProvider.getBy(id: null);
      expect(retrievedExpense, isNull);
      expect(preferences.getStringList("Expenses").length, equals(2));
    });
  });
}
