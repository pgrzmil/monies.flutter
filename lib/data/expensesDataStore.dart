import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'models/expense.dart';

class ExpensesDataStore extends ChangeNotifier {
  final List<Expense> _expenses = [];

  Future<List<Expense>> getAll() async {
    if (_expenses.length == 0) {
      //Delayed is used to simulate longer response tim form webservice or local db
      _expenses.addAll(await Future.delayed(Duration(seconds: 3), () => _loadFromJson()));
      notifyListeners();
    }
    return _expenses;
  }

  Future<List<Expense>> _loadFromJson() async {
    String fileContents = await rootBundle.loadString('assets/mockExpenses.json');

    if (fileContents == null) {
      return [];
    }
    final parsed = json.decode(fileContents.toString()).cast<Map<String, dynamic>>();
    return parsed.map<Expense>((json) => new Expense.fromJson(json)).toList();
  }

  update(Expense expense) {
    if (!_expenses.any((e) => e.id == expense.id)) {
      _expenses.add(expense);
    }
    notifyListeners();
  }

  addRandom() {
    var random = Random();
    _expenses.add(Expense.fromValues("title ${random.nextInt(123)}", "location", random.nextDouble() * 100));
    notifyListeners();
  }
}
