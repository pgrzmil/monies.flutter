import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'expense.g.dart';

@JsonSerializable(explicitToJson: true, )
class Expense {
  final String id;
  String title;
  String location;
  double amount;

  String get amountString {
    return '$amount zł';
  }

  Expense(this.id, this.title, this.location, this.amount);
  Expense.fromValues(this.title, this.location, this.amount) : id = Uuid().v4();

  factory Expense.empty() => Expense.fromValues("", "", 0);

  //JSON methods
  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseToJson(this);
  factory Expense.fromJsonString(String jsonString) => _$ExpenseFromJson(json.decode(jsonString));
  String toJsonString() => json.encode(_$ExpenseToJson(this));
}
