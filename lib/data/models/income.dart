import 'package:monies/utils/mathParser.dart';

import 'modules.dart';
part 'income.g.dart';

@JsonSerializable()
class Income implements BaseModel, WithAmount, WithDate {
  final String id;
  final String userId;
  String title;
  String _amountExpression;
  String get amountExpression => _amountExpression;
  set amountExpression(String value) {
    _amountExpression = value;
    _calculatedAmount = null;
    amount;
  }
  DateTime date;

  String get amountString => Format.money(amount);
  String get dateString => Format.date(date);

  Income(this.id, this.title, String amountExpression, this.date, this.userId){
    this.amountExpression = amountExpression;
  }

  Income.fromValues(this.title, String amountExpression, this.date, this.userId) : id = Uuid().v4(){
    this.amountExpression = amountExpression;
  }

  factory Income.empty(String userId) => Income.fromValues("", "", DateTime.now(), userId);

  double _calculatedAmount;
  @override
  double get amount {
    if (_calculatedAmount == null) {
      _calculatedAmount = MathExpressionParser.parseValue(this.amountExpression);
    }
    return _calculatedAmount ?? 0;
  }

  //JSON methods
  static Income fromJsonMap(Map<String, dynamic> json) => _$IncomeFromJson(json);
  Map<String, dynamic> toJsonMap() => _$IncomeToJson(this);
  static Income fromJsonString(String jsonString) => _$IncomeFromJson(json.decode(jsonString));
  String toJsonString() => json.encode(_$IncomeToJson(this));
}
