import 'modules.dart';
part 'income.g.dart';

@JsonSerializable()
class Income implements BaseModel, WithAmount, WithDate {
  final String id;
  final String userId;
  String title;
  double amount;
  DateTime date;

  String get amountString => Format.money(amount);
  String get dateString => Format.date(date);

  Income(this.id, this.title, this.amount, this.date, this.userId);
  Income.fromValues(this.title, this.amount, this.date, this.userId) : id = Uuid().v4();

  factory Income.empty(String userId) => Income.fromValues("", 0, DateTime.now(), userId);

  //JSON methods
  static Income fromJsonMap(Map<String, dynamic> json) => _$IncomeFromJson(json);
  Map<String, dynamic> toJsonMap() => _$IncomeToJson(this);
  static Income fromJsonString(String jsonString) => _$IncomeFromJson(json.decode(jsonString));
  String toJsonString() => json.encode(_$IncomeToJson(this));
}
