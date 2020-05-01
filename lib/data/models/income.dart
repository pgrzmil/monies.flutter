import 'package:monies/data/models/incomeType.dart';
import 'package:monies/utils/mathParser.dart';

import 'modules.dart';
part 'income.g.dart';

@JsonSerializable()
class Income implements BaseModel, WithAmount, WithDate {
  final String id;
  final String userId;
  String title;
  IncomeType type;

  DateTime date;
  String get dateString => Format.date(date);

  String _amountExpression;
  String get amountExpression => _amountExpression;
  set amountExpression(String value) {
    _amountExpression = value;
    //set to null so value will be recalculated and assigned again
    _calculatedAmount = null;
    amount;
  }

  String get amountString => Format.money(amount);

  //added to store calculated amount and not parse amount expression and performing it every time
  double _calculatedAmount;
  @override
  double get amount {
    if (_calculatedAmount == null) {
      _calculatedAmount = MathExpressionParser.parseValue(this.amountExpression);
    }
    return _calculatedAmount ?? 0;
  }

  Income(this.id, this.title, String amountExpression, this.date, this.type, this.userId) {
    this.amountExpression = amountExpression;
  }

  Income.fromValues(this.title, String amountExpression, this.date, this.type, this.userId) : id = Uuid().v4() {
    this.amountExpression = amountExpression;
  }

  factory Income.empty(String userId) => Income.fromValues("", "", DateTime.now(), IncomeType.other, userId);

  //JSON methods
  static Income fromJsonMap(Map<String, dynamic> json) => _$IncomeFromJson(json);
  Map<String, dynamic> toJsonMap() => _$IncomeToJson(this);
  static Income fromJsonString(String jsonString) => _$IncomeFromJson(json.decode(jsonString));
  String toJsonString() => json.encode(_$IncomeToJson(this));
}

extension Editable on Income {
  bool get isEditable => true;//type != IncomeType.lastMonthBalance;
}
