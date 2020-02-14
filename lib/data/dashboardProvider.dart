import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:monies/data/incomesProvider.dart';
import 'package:monies/data/models/expense.dart';
import 'package:monies/utils/formatters.dart';
import 'extensions/withAmount.dart';
import 'expensesProvider.dart';

class DashboardProvider extends ChangeNotifier {
  final ExpensesProvider _expensesProvider;
  final IncomesProvider _incomesProvider;

  DateTime _currentDate = DateTime.now();

  DashboardProvider(this._expensesProvider, this._incomesProvider);

  String get title => Format.monthAndYear(_currentDate);

  Iterable<Expense> get lastExpenses => _expensesProvider.getLatest(3, _currentDate.month, _currentDate.year);

  DateTime get currentDate => _currentDate;

  double get expensesSum {
    return _expensesProvider.getForMonth(_currentDate.month, _currentDate.year).sum();
  }

  double get incomesSum {
    return _incomesProvider.getForMonth(_currentDate.month, _currentDate.year).sum();
  }

  double get balance {
    return incomesSum - expensesSum;
  }

  void switchToNextMonth() {
    _currentDate = Jiffy(_currentDate).add(months: 1);
    notifyListeners();
  }

  void switchToPreviousMonth() {
    _currentDate = Jiffy(_currentDate).subtract(months: 1);
    notifyListeners();
  }
}
