import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:monies/data/expensesDataStore.dart';
import 'package:monies/data/models/expense.dart';

class ExpensesDataStoreHelpers {
  static addRandomExpense(ExpensesDataStore dataStore) {
    final random = Random();
    final expense = Expense.fromValues("title ${random.nextInt(123)}", "location", random.nextDouble() * 100);
    dataStore.updateWith(expense);
  }

  static void loadExpensesFromFile(ExpensesDataStore dataStore, String path) async {
    String fileContents = await rootBundle.loadString(path); //'assets/mockExpenses.json'
    if (fileContents == null) return;
    
    final parsed = json.decode(fileContents).cast<Map<String, dynamic>>();
    parsed.forEach((json) => dataStore.updateWith(Expense.fromJson(json)));
  }
}
