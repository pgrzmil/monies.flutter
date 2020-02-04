import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/data/models/category.dart';
import 'package:monies/data/models/expense.dart';

class TestDataHelpers {
  static Expense addRandomExpense(ExpensesProvider expensesProvider) {
    final random = Random();
    final expense = Expense.fromValues("title ${random.nextInt(123)}", "location", random.nextDouble() * 100, DateTime.now());
    expensesProvider.add(expense);
    return expense;
  }

  static void loadExpensesFromAssetFile(ExpensesProvider expensesProvider, String path) async {
    String fileContents = await rootBundle.loadString(path);
    if (fileContents == null) return;

    final parsed = json.decode(fileContents).cast<Map<String, dynamic>>();
    parsed.forEach((json) => expensesProvider.add(Expense.fromJson(json)));
  }

  static void loadTestExpenses(ExpensesProvider expensesProvider) {
    expensesProvider.add(Expense("1", "Zakupy tygodniowe", "Lidl", 136.65, DateTime(2019, 12, 19)));
    expensesProvider.add(Expense("2", "Mycie samochodu", "Myjnia felicity", 9.00, DateTime(2019, 12, 9)));
    expensesProvider.add(Expense("3", "Paliwo", "Orlen", 249.78, DateTime(2019, 12, 6)));
    expensesProvider.add(Expense("4", "Spodnie, koszulka", "Medicine", 149.98, DateTime(2019, 12, 15)));
    expensesProvider.add(Expense("5", "Rachunek za prąd", "PGE", 173.42, DateTime(2019, 12, 2)));
  }

  static void loadTestCategories(CategoriesProvider categoriesProvider) {
    categoriesProvider.add(ExpenseCategory("cat1", "Rozrywka", 4));
    categoriesProvider.add(ExpenseCategory("cat2", "Transport i paliwo", 2));
    categoriesProvider.add(ExpenseCategory("cat3", "Wydatki codzienne", 1));
    categoriesProvider.add(ExpenseCategory("cat4", "Odziez i dodatki", 3));
  }
}
