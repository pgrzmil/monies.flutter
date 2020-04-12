import 'package:flutter/material.dart';
import 'package:monies/data/models/category.dart';
import 'package:monies/widgets/categories/categoryIcon.dart';

class CategoriesListItem extends StatelessWidget {
  final ExpenseCategory category;
  final Widget trailing;

  CategoriesListItem({this.category, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: CategoryIcon(category: category),
        title: Text(category.title),
        trailing: trailing,
      ),
    );
  }
}
