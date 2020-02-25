import 'package:flutter/material.dart';
import 'package:monies/data/models/category.dart';
import 'package:monies/widgets/categories/categoryIcon.dart';

class CategoriesListItem extends StatelessWidget {
  final ExpenseCategory category;

  CategoriesListItem({this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: CategoryIcon(category: category),
        title: Text(category.title),
      ),
    );
  }
}
