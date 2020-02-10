import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'baseModel.dart';
part 'category.g.dart';

@JsonSerializable(explicitToJson: true)
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

  factory ExpenseCategory.empty() => ExpenseCategory.fromValues("", 0, defaultColor.value, defaultIcon.codePoint);

  //JSON methods
  static ExpenseCategory fromJsonString(String jsonString) => _$ExpenseCategoryFromJson(json.decode(jsonString));
  String toJsonString() => json.encode(_$ExpenseCategoryToJson(this));
}
