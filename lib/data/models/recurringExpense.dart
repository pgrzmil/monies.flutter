import 'package:monies/data/models/expense.dart';

import 'modules.dart';
part 'recurringExpense.g.dart';

enum Frequency { monthly }

@JsonSerializable(explicitToJson: true)
class RecurringExpense extends Expense {
  Frequency frequency;
  DateTime startDate;

  String get startDateString => Format.date(startDate);

  RecurringExpense(String id, String title, String location, double amount, DateTime date, String categoryId, this.startDate, this.frequency)
      : super(id, title, location, amount, date, categoryId);
  RecurringExpense.fromValues(String title, String location, double amount, DateTime date, String categoryId, this.startDate, this.frequency)
      : super.fromValues(title, location, amount, date, categoryId);

  factory RecurringExpense.empty() => RecurringExpense.fromValues("", "", 0, null, null, DateTime.now(), Frequency.monthly);

  //JSON methods
  static RecurringExpense fromJsonMap(Map<String, dynamic> json) => _$RecurringExpenseFromJson(json);
  Map<String, dynamic> toJsonMap() => _$RecurringExpenseToJson(this);
  static RecurringExpense fromJsonString(String jsonString) => _$RecurringExpenseFromJson(json.decode(jsonString));
  String toJsonString() => json.encode(_$RecurringExpenseToJson(this));
}
