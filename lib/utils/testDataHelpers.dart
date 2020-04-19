import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/data/incomesProvider.dart';
import 'package:monies/data/models/category.dart';
import 'package:monies/data/models/expense.dart';
import 'package:monies/data/models/income.dart';
import 'package:monies/data/models/incomeType.dart';
import 'package:monies/data/models/recurringExpense.dart';
import 'package:monies/data/recurringExpensesProvider.dart';

class TestDataHelpers {
  static Future<Expense> addRandomExpense(ExpensesProvider expensesProvider, userId) async {
    final random = Random();
    final amount = random.nextInt(20000) / 100;
    final expense = Expense.fromValues("title ${random.nextInt(123)}", "location", "=$amount", DateTime.now(), "", userId);
    await expensesProvider.add(expense);
    return expense;
  }

  static void loadExpensesFromAssetFile(ExpensesProvider expensesProvider, String path) async {
    String fileContents = await rootBundle.loadString(path);
    if (fileContents == null) return;

    final parsed = json.decode(fileContents).cast<Map<String, dynamic>>();
    parsed.forEach((json) => expensesProvider.add(Expense.fromJsonMap(json)));
  }

  static void loadTestExpenses(ExpensesProvider expensesProvider, String userId) {
    expensesProvider.add(Expense("1", "Zakupy tygodniowe", "Lidl", "=135.65", DateTime(2019, 12, 19), "cat0", userId));
    expensesProvider.add(Expense("2", "Mycie samochodu", "Myjnia felicity", "=9.0", DateTime(2019, 12, 9), "cat2", userId));
    expensesProvider.add(Expense("3", "Paliwo", "Orlen", "=249.78", DateTime(2019, 12, 6), "cat2", userId));
    expensesProvider.add(Expense("4", "Spodnie, koszulka", "Medicine", "=149.98", DateTime(2019, 12, 15), "cat4", userId));
    expensesProvider.add(Expense("5", "Rachunek za prąd", "PGE", "=173.42", DateTime(2019, 12, 2), "cat1", userId));
  }

  static void loadTestCategories(CategoriesProvider categoriesProvider, String userId) {
    categoriesProvider.add(ExpenseCategory("cat1", "Rachunki", 4, Colors.grey[500].value, Icons.event.codePoint, userId));
    categoriesProvider.add(ExpenseCategory("cat2", "Transport i paliwo", 2, Colors.green[500].value, Icons.train.codePoint, userId));
    categoriesProvider.add(ExpenseCategory("cat0", "Wydatki codzienne", 0, Colors.red[500].value, Icons.shopping_basket.codePoint, userId));
    categoriesProvider.add(ExpenseCategory("cat4", "Odziez i dodatki", 3, Colors.blue[500].value, Icons.spa.codePoint, userId));
  }

  static void loadIncomes(IncomesProvider incomesProvider, String userId, {DateTime forMonth}) {
    incomesProvider.add(Income("inc1", "Pensja", "=4550", forMonth, IncomeType.salary, userId));
    incomesProvider.add(Income("inc2", "Zwrot wydatków", "=380", forMonth, IncomeType.other, userId));
  }

  static void loadTestRecurringExpenses(RecurringExpensesProvider expensesProvider, String userId) {
    expensesProvider
        .add(RecurringExpense("rec1", "Rachunek za internet", "UPC", "=48.0", null, "cat0", DateTime(2019, 12, 9), Frequency.monthly, userId));
    expensesProvider.add(RecurringExpense("rec2", "HBO GO", "", "=19.99", null, "cat2", DateTime(2019, 12, 18), Frequency.monthly, userId));
    expensesProvider
        .add(RecurringExpense("rec3", "Rachunek za telefon", "Orange", "=38.0", null, "cat2", DateTime(2019, 12, 7), Frequency.monthly, userId));
  }
}
