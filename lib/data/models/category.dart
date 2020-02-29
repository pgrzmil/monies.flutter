import 'modules.dart';
import 'package:flutter/material.dart';
part 'category.g.dart';

@JsonSerializable()
class ExpenseCategory implements BaseModel {
  final String id;
  String title;
  int order;
  int colorCode;
  int iconCode;

  static get defaultIcon => Icons.attach_money;
  static get defaultColor => Colors.green[400];

  IconData get icon => IconData(iconCode ?? defaultIcon.codePoint, fontFamily: 'MaterialIcons');
  Color get color => Color(colorCode ?? defaultColor.value);

  ExpenseCategory(this.id, this.title, this.order, this.colorCode, this.iconCode);
  ExpenseCategory.fromValues(this.title, this.order, this.colorCode, this.iconCode) : id = Uuid().v4();

  factory ExpenseCategory.empty() => ExpenseCategory.fromValues("", 0, null, null);

  //JSON methods
  static ExpenseCategory fromJsonMap(Map<String, dynamic> json) => _$ExpenseCategoryFromJson(json);
  Map<String, dynamic> toJsonMap() => _$ExpenseCategoryToJson(this);
  static ExpenseCategory fromJsonString(String jsonString) => _$ExpenseCategoryFromJson(json.decode(jsonString));
  String toJsonString() => json.encode(_$ExpenseCategoryToJson(this));
}
