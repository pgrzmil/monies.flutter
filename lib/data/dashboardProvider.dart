import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:monies/data/analyticsProvider.dart';
import 'package:monies/data/incomesProvider.dart';
import 'package:monies/data/models/expense.dart';
import 'package:monies/utils/formatters.dart';
import 'extensions/withAmount.dart';
import 'expensesProvider.dart';

class DashboardProvider extends ChangeNotifier {
  ExpensesProvider _expensesProvider;
  IncomesProvider _incomesProvider;
  AnalyticsProvider _analyticsProvider;

  DateTime _currentDate = DateTime.now();

  String get title => Format.monthAndYear(_currentDate);

  Iterable<Expense> get lastExpenses => _expensesProvider.getLatest(3, _currentDate.month, _currentDate.year);

  DateTime get currentDate => _currentDate;

  double get expensesSum => _expensesProvider.getForMonth(_currentDate.month, _currentDate.year).sum();
  String get expensesSumText => Format.money(expensesSum);

  double get incomesSum => _incomesProvider.getForMonth(_currentDate.month, _currentDate.year).sum();
  String get incomesSumText => Format.money(incomesSum);

  double get balance => incomesSum - expensesSum;
  String get balanceText => Format.money(balance);

  List<Series<CategoryWithSum, String>> get categoriesChartDate {
    return _analyticsProvider.categoriesChartData;
  }

  bool get categoriesChartAnimated {
    return categoriesChartDate.first.id != "EmptyChart";
  }

  void switchToNextMonth() {
    _currentDate = Jiffy(_currentDate).add(months: 1);
    _analyticsProvider.setCurrentDate(_currentDate);
    notifyListeners();
  }

  void switchToPreviousMonth() {
    _currentDate = Jiffy(_currentDate).subtract(months: 1);
    _analyticsProvider.setCurrentDate(_currentDate);
    notifyListeners();
  }

  DashboardProvider setProviders({ExpensesProvider expensesProvider, IncomesProvider incomesProvider, AnalyticsProvider analyticsProvider}) {
    _incomesProvider = incomesProvider;
    _expensesProvider = expensesProvider;
    _analyticsProvider = analyticsProvider;
    notifyListeners();
    return this;
  }
}
