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

  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');
  Color get color => Color(colorCode);

  ExpenseCategory(this.id, this.title, this.order, this.colorCode, this.iconCode);
  ExpenseCategory.fromValues(this.title, this.order) : id = Uuid().v4();

  //JSON methods
  static ExpenseCategory fromJsonString(String jsonString) => _$ExpenseCategoryFromJson(json.decode(jsonString));
  String toJsonString() => json.encode(_$ExpenseCategoryToJson(this));
}
