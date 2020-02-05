import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'baseModel.dart';
part 'category.g.dart';

@JsonSerializable(explicitToJson: true)
class ExpenseCategory implements BaseModel {
  final String id;
  String title;
  int order;

  ExpenseCategory(this.id, this.title, this.order);
  ExpenseCategory.fromValues(this.title, this.order) : id = Uuid().v4();

  //JSON methods
  static ExpenseCategory fromJsonString(String jsonString) => _$ExpenseCategoryFromJson(json.decode(jsonString));
  String toJsonString() => json.encode(_$ExpenseCategoryToJson(this));
}
