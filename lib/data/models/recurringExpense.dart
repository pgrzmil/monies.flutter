import 'package:monies/data/models/expense.dart';

import 'modules.dart';
part 'recurringExpense.g.dart';

enum Frequency { monthly }

@JsonSerializable(explicitToJson: true)
class RecurringExpense extends Expense {
  Frequency frequency;
  DateTime startDate;

  RecurringExpense(id, title, location, amount, date, categoryId, this.startDate, this.frequency)
      : super(id, title, location, amount, date, categoryId);
  RecurringExpense.fromValues(title, location, amount, date, categoryId, this.startDate, this.frequency)
      : super.fromValues(title, location, amount, date, categoryId);

  factory RecurringExpense.empty() => RecurringExpense.fromValues("", "", 0, null, null, DateTime.now(), Frequency.monthly);

  //JSON methods
  static RecurringExpense fromJsonString(String jsonString) => _$RecurringExpenseFromJson(json.decode(jsonString));
  String toJsonString() => json.encode(_$RecurringExpenseToJson(this));
}
