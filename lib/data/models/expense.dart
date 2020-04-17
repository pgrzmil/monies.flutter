import 'package:monies/utils/mathParser.dart';

import 'modules.dart';
part 'expense.g.dart';

@JsonSerializable(explicitToJson: true)
class Expense implements BaseModel, WithAmount, WithDate {
  final String id;
  final String userId;
  String title;
  String location;
  String _amountExpression;
  String get amountExpression => _amountExpression;
  set amountExpression(String value) {
    _amountExpression = value;
    _calculatedAmount = null;
    amount;
  }

  DateTime date;
  String categoryId;
  final String recurringExpenseId;

  String get amountString => Format.money(amount);
  String get dateString => Format.date(date);
  String get displayTitle => location.isNotEmpty ? title + " - " + location : title;

  Expense(this.id, this.title, this.location, String amountExpression, this.date, this.categoryId, this.userId, {this.recurringExpenseId}) {
    this.amountExpression = amountExpression;
  }

  Expense.fromValues(this.title, this.location, String amountExpression, this.date, this.categoryId, this.userId, {this.recurringExpenseId})
      : id = Uuid().v4() {
    this.amountExpression = amountExpression;
  }

  factory Expense.empty(String userId) => Expense.fromValues("", "", "", DateTime.now(), null, userId);

  double _calculatedAmount;
  @override
  double get amount {
    if (_calculatedAmount == null) {
      _calculatedAmount = MathExpressionParser.parseValue(this.amountExpression);
    }
    return _calculatedAmount ?? 0;
  }

  //JSON methods
  static Expense fromJsonMap(Map<String, dynamic> json) => _$ExpenseFromJson(json);
  Map<String, dynamic> toJsonMap() => _$ExpenseToJson(this);
  static Expense fromJsonString(String jsonString) => _$ExpenseFromJson(json.decode(jsonString));
  String toJsonString() => json.encode(_$ExpenseToJson(this));
}
