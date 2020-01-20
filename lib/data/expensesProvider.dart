import 'dart:convert';

import 'package:flutter/services.dart';

import 'models/expense.dart';

class ExpensesProvider {
  List<Expense> expenses;

  Future<List<Expense>> getAll() async {
    if(expenses == null) {
      //Delayed is used to simulate longer response tim form webservice or local db
      expenses = await Future.delayed(Duration(seconds: 3), () => loadFromJson());
    }
    return expenses; 
  }

  Future<List<Expense>> loadFromJson() async {
    String fileContents = await rootBundle.loadString('assets/mockExpenses.json');

    if(fileContents==null){
      return [];
    }
    final parsed = json.decode(fileContents.toString()).cast<Map<String, dynamic>>();
    return parsed.map<Expense>((json) => new Expense.fromJson(json)).toList();
  }
}