import 'modules.dart';
part 'expense.g.dart';

@JsonSerializable(explicitToJson: true)
class Expense implements BaseModel, WithAmount, WithDate {
  final String id;
  String title;
  String location;
  double amount;
  DateTime date;
  String categoryId;

  String get amountString => Format.money(amount);
  String get dateString => Format.date(date);
  String get displayTitle => location.isNotEmpty ? title + " - " + location : title;

  Expense(this.id, this.title, this.location, this.amount, this.date, this.categoryId);
  Expense.fromValues(this.title, this.location, this.amount, this.date, this.categoryId) : id = Uuid().v4();

  factory Expense.empty() => Expense.fromValues("", "", 0, DateTime.now(), null);

  //JSON methods
  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseToJson(this);
  static Expense fromJsonString(String jsonString) => _$ExpenseFromJson(json.decode(jsonString));
  String toJsonString() => json.encode(_$ExpenseToJson(this));
}
