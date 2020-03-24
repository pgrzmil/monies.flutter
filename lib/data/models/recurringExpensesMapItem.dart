import 'modules.dart';
part 'recurringExpensesMapItem.g.dart';

@JsonSerializable()
class RecurringExpensesMapItem implements BaseModel {
  final String id;
  final String userId;
  String title;

  RecurringExpensesMapItem(this.id, this.title, this.userId);
  RecurringExpensesMapItem.fromValues(this.title, this.userId) : id = Uuid().v4();

  factory RecurringExpensesMapItem.empty(String userId) => RecurringExpensesMapItem.fromValues("", userId);

  //JSON methods
  static RecurringExpensesMapItem fromJsonMap(Map<String, dynamic> json) => _$RecurringExpensesMapItemFromJson(json);
  Map<String, dynamic> toJsonMap() => _$RecurringExpensesMapItemToJson(this);
  static RecurringExpensesMapItem fromJsonString(String jsonString) => _$RecurringExpensesMapItemFromJson(json.decode(jsonString));
  String toJsonString() => json.encode(_$RecurringExpensesMapItemToJson(this));
}
