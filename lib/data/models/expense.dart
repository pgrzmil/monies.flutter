import 'package:uuid/uuid.dart';

class Expense {
  final String id;
  String title;
  String location;
  double amount;

  String get amountString {
    return '$amount zł';
  }

  Expense(this.title, this.location, this.amount) : id = Uuid().v4();

  Expense.fromValues(this.id, this.title, this.location, this.amount);
  
  factory Expense.empty() => Expense("", "", 0);

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense.fromValues(json['id'] as String, 
                   json['title'] as String,
                   json['location'] as String,
                   json['amount'] as double);
  }
}