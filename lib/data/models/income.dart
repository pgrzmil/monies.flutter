import 'modules.dart';
part 'income.g.dart';

@JsonSerializable()
class Income implements BaseModel {
  final String id;
  String title;
  double amount;
  DateTime date;

  String get amountString => Format.money(amount);
  String get dateString => Format.date(date);

  Income(this.id, this.title, this.amount, this.date);
  Income.fromValues(this.title, this.amount, this.date) : id = Uuid().v4();

  factory Income.empty() => Income.fromValues("", 0, DateTime.now());

  //JSON methods
  static Income fromJsonString(String jsonString) => _$IncomeFromJson(json.decode(jsonString));
  String toJsonString() => json.encode(_$IncomeToJson(this));
}
