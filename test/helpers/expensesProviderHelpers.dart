import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/data/models/expense.dart';

class ExpensesProviderHelpers {
  static Expense addRandomExpense(ExpensesProvider expensesProvider) {
    final random = Random();
    final expense = Expense.fromValues("title ${random.nextInt(123)}", "location", random.nextDouble() * 100);
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
    expensesProvider.add(Expense("1", "Zakupy tygodniowe", "Lidl", 136.65));
    expensesProvider.add(Expense("2", "Mycie samochodu", "Myjnia felicity", 9.00));
    expensesProvider.add(Expense("3", "Paliwo", "Orlen", 249.78));
    expensesProvider.add(Expense("4", "Spodnie, koszulka", "Medicine", 149.98));
    expensesProvider.add(Expense("5", "Rachunek za prąd", "PGE", 173.42));
  }
}
