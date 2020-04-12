import 'package:monies/utils/icons.dart';

import 'modules.dart';
import 'package:flutter/material.dart';
part 'category.g.dart';

@JsonSerializable()
class ExpenseCategory implements BaseModel {
  final String id;
  final String userId;
  String title;
  int order;
  int colorCode;
  int iconCode;

  static get defaultIcon => Icons.attach_money;
  static get defaultColor => Colors.green[400];

  String get iconString => IconsHelper.iconNameFromCode(iconCode);

  IconData get icon => IconsHelper.iconFromCode(iconCode, defaultIcon);
  Color get color => Color(colorCode ?? defaultColor.value);

  ExpenseCategory(this.id, this.title, this.order, this.colorCode, this.iconCode, this.userId);
  ExpenseCategory.fromValues(this.title, this.order, this.colorCode, this.iconCode, this.userId) : id = Uuid().v4();

  factory ExpenseCategory.empty(String userId) => ExpenseCategory.fromValues("", 0, null, null, userId);

  //JSON methods
  static ExpenseCategory fromJsonMap(Map<String, dynamic> json) => _$ExpenseCategoryFromJson(json);
  Map<String, dynamic> toJsonMap() => _$ExpenseCategoryToJson(this);
  static ExpenseCategory fromJsonString(String jsonString) => _$ExpenseCategoryFromJson(json.decode(jsonString));
  String toJsonString() => json.encode(_$ExpenseCategoryToJson(this));
}
