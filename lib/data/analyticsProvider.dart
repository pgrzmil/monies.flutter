import 'package:flutter/material.dart';
import 'package:monies/data/models/category.dart';
import 'categoriesProvider.dart';
import 'extensions/withAmount.dart';
import 'expensesProvider.dart';

class AnalyticsProvider extends ChangeNotifier {
  ExpensesProvider _expensesProvider;
  CategoriesProvider _categoriesProvider;

  Map<ExpenseCategory, double> sumByCategory(int month, int year){
    Map<ExpenseCategory, double> result = Map<ExpenseCategory, double>();

    for (var category in _categoriesProvider.getAll()) {
      final sum = _expensesProvider.getForMonth(month, year).filterByCategory(category.id).sum();
      result[category] = sum;
    }

    return result;
  }

  AnalyticsProvider setProviders({ExpensesProvider expensesProvider, CategoriesProvider categoriesProvider}) {
    _categoriesProvider = categoriesProvider;
    _expensesProvider = expensesProvider;
    notifyListeners();
    return this;
  }
}
